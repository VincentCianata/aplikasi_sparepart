from flask import Blueprint, jsonify, request
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import jwt_required, get_jwt_identity, create_access_token
from app import db
from models import User, SparePart, Transaction, Cart

bp = Blueprint('api', __name__)

@bp.route('/auth/register', methods=['POST'])
def register_user():
    data = request.get_json()
    if User.query.filter_by(email=data['email']).first():
        return jsonify({"message": "User already exists"}), 400
    
    hashed_password = generate_password_hash(data['password'])
    user = User(email=data['email'], password=hashed_password)
    db.session.add(user)
    db.session.commit()
    return jsonify({"message": "User registered successfully"}), 201

@bp.route('/auth/login', methods=['POST'])
def login_user():
    data = request.get_json()
    user = User.query.filter_by(email=data['email']).first()
    if not user or not check_password_hash(user.password, data['password']):
        return jsonify({"message": "Email atau password salah"}), 401
    
    token = create_access_token(identity=str(user.id))
    return jsonify({"message": "Login successful", "user_id":user.id, "access_token": token}), 200

@bp.route('/spareparts', methods=['GET'])
def get_spare_parts():
    parts = SparePart.query.all()
    return jsonify([{"id": p.id, "name": p.name, "price": p.price, "stock": p.stock, "image_url": p.image_url, "description": p.description, "category": p.category} for p in parts]), 200

@bp.route('/history', methods=['GET'])
@jwt_required()
def get_transaction_history(): 
    user_id = get_jwt_identity()
    transactions = Transaction.query.filter_by(user_id=user_id).all()
    return jsonify([{"id": t.id, "spare_part_id": t.spare_part_id, "quantity": t.quantity, "total_price": t.total_price} for t in transactions]), 200

@bp.route('/cart/<int:user_id>/<int:spare_part_id>', methods=['POST'])
@jwt_required()
def add_to_cart(user_id, spare_part_id):
    data = request.get_json()
    quantity = data.get('quantity', 1)
    cart_item = Cart.query.filter_by(user_id=user_id, spare_part_id=spare_part_id).first()
    if cart_item:
        cart_item.quantity += quantity
    else:
        cart_item = Cart(user_id=user_id, spare_part_id=spare_part_id, quantity=quantity)
        db.session.add(cart_item)
    db.session.commit()
    token = create_access_token(identity=str(user_id))
    return jsonify({"message": "Added to cart", "access_token": token}), 201


@bp.route('/cart/<int:user_id>', methods=['GET'])
@jwt_required()
def get_cart(user_id):
    cart_items = Cart.query.filter_by(user_id=user_id).all()
    token = create_access_token(identity=str(user_id))
    return jsonify([
        {
            "id": item.id,
            "spare_part_id": item.spare_part_id,
            "quantity": item.quantity,
            "access_token": token
        } for item in cart_items
    ]), 200


@bp.route('/cart/<int:user_id>/<int:spare_part_id>', methods=['DELETE'])
@jwt_required()
def remove_from_cart(user_id, spare_part_id):
    cart_item = Cart.query.filter_by(user_id=user_id, spare_part_id=spare_part_id).first()
    if cart_item:
        db.session.delete(cart_item)
        db.session.commit()
        token = create_access_token(identity=str(user_id))
        return jsonify({"message": "Removed from cart", "access_token": token}), 200
    return jsonify({"message": "Item not found"}), 404


@bp.route('/cart/clear/<int:user_id>', methods=['DELETE'])
@jwt_required()
def clear_cart(user_id):
    Cart.query.filter_by(user_id=user_id).delete()
    db.session.commit()
    token = create_access_token(identity=str(user_id))
    return jsonify({"message": "Cart cleared", "access_token" : token}), 200