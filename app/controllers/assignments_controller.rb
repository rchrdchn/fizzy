class AssignmentsController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    @bubble.assignments.create!(assignee: find_assignee)
    redirect_to bucket_bubble_url(@bucket, @bubble)
  end

  private
    def find_assignee
      @bucket.users.active.find(params[:assignee_id])
    end
end
