class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :admin
      can :manage, :all
    end

    if user.role? :manager
      #can :read, :all
      can [:create, :read, :update], User, role: ["Manager", "Shipper"]
      can [:create, :read, :update, :destroy], Item
      can [:create, :read], ItemPrice
      can [:create, :read], Purchase
      can :read, [Customer, School, Order]
    end

    if user.role? :shipper
      can [:read, :update], User, id: user.id
      can [:read, :update], OrderItem
      can :read, Item
    end

    if user.role? :customer
      can [:read, :update], User, id: user.id
      can [:create, :read], School
      can :read, Item, active: true
      can :read, ItemPrice, item: {active: true}, category: "wholesale", end_date: nil
      can [:create, :read], Order, user_id: user.id
      can :read, OrderItem, order: {user_id: user.id}

      can [:update, :destroy], Order, Order.not_shipped do |order|
        order if order.user_id == user.id
      end

      can [:create, :update, :destroy], OrderItem do |order_item|
        order_item if Order.not_shipped.all.include?(order_item.order)
      end
    end

    if user.role.nil?
      can :create, User
      can :create, School
      can :read, Item, active: true
      can :read, ItemPrice, item: {active: true}, category: "wholesale", end_date: nil
    end
  end
end
