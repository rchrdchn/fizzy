require "test_helper"

class Public::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
    @collection = collections(:writebook)
    @card = cards(:logo)
    @collection.publish
  end

  test "show" do
    get public_collection_card_path(@collection.publication.key, @card)
    assert_response :success
  end

  test "not found if the collection is not published" do
    @collection.unpublish
    get public_collection_card_path(@collection.publication.key, @card)
    assert_response :not_found
  end
end
