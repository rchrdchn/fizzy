module Account::Billing
  extend ActiveSupport::Concern

  included do
    has_one :subscription, class_name: "Account::Subscription", dependent: :destroy
  end

  def plan
    active_subscription&.plan || Plan.free
  end

  def active_subscription
    subscription if subscription&.active?
  end

  def subscribed?
    subscription.present?
  end
end
