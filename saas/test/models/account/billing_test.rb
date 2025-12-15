require "test_helper"

class Account::BillingTest < ActiveSupport::TestCase
  test "active subscription" do
    account = Account.create!(name: "Test")

    # No subscription
    assert_nil account.active_subscription

    # Subscription but it is not active
    account.create_subscription!(plan_key: "monthly_v1", status: "canceled", stripe_customer_id: "cus_test")
    assert_nil account.active_subscription

    # Active subscription exists
    account.subscription.update!(status: "active")
    assert_equal account.subscription, account.active_subscription
  end
end
