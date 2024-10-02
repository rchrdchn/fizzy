module CommentsHelper
  def render_comments_and_boosts(bubble)
    combined_collection = combine_and_sort_items(bubble)

    safe_join([
      render_creator_summary(bubble, combined_collection),
      render_remaining_items(combined_collection)
    ])
  end

  private
    def combine_and_sort_items(bubble)
      (bubble.comments + bubble.boosts + bubble.assignments).sort_by(&:created_at)
    end

    def render_creator_summary(bubble, combined_collection)
      content_tag(:div, class: "comment--upvotes flex-inline flex-wrap align-start gap fill-white border-radius center position-relative") do
        [
          creator_info(bubble),
          initial_assignment_info(combined_collection),
          render_initial_boosts(combined_collection)
        ].compact.join(", ").html_safe
      end
    end

    def creator_info(bubble)
      "Added by #{bubble.creator.name} #{time_ago_in_words(bubble.created_at)} ago"
    end

    def initial_assignment_info(combined_collection)
      initial_assignment = combined_collection.find { |item| item.is_a?(Assignment) }
      "assigned to #{initial_assignment.assignee.name}" if initial_assignment
    end

    def render_initial_boosts(combined_collection)
      grouped_boosts = combined_collection.take_while { |item| item.is_a?(Boost) }
      return if grouped_boosts.empty?

      user_boosts = grouped_boosts.group_by(&:creator).transform_values(&:count)
      boost_summaries = user_boosts.map { |user, count| "#{user.name} +#{count}" }
      boost_summaries.to_sentence
    end

    def render_remaining_items(combined_collection)
      initial_count = combined_collection.take_while { |item| !item.is_a?(Comment) }.count
      items = combined_collection.drop(initial_count)

      safe_join(items.chunk_while { |i, j| grouped_item?(i) && grouped_item?(j) }.map do |chunk|
        if chunk.first.is_a?(Comment)
          render "comments/comment", comment: chunk.first
        else
          render_grouped_items(chunk)
        end
      end)
    end

    def grouped_item?(item)
      item.is_a?(Boost) || item.is_a?(Assignment)
    end

    def render_grouped_items(items)
      return if items.empty?

      content_tag(:div, class: "comment--upvotes flex-inline flex-wrap align-start gap fill-white border-radius center position-relative") do
        [
          render_grouped_boosts(items.select { |item| item.is_a?(Boost) }),
          render_grouped_assignments(items.select { |item| item.is_a?(Assignment) })
        ].flatten.compact.to_sentence.html_safe
      end
    end

    def render_grouped_boosts(boosts)
      return if boosts.empty?
      boosts.group_by(&:creator).map { |user, user_boosts| "#{user.name} +#{user_boosts.count}" }
    end

    def render_grouped_assignments(assignments)
      assignments.map { |assignment| "Assigned to #{assignment.assignee.name} #{time_ago_in_words(assignment.created_at)} ago" }
    end
end
