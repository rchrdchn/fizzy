class Command::GetInsight < Command
  include ::Ai::Prompts, Command::Cards

  store_accessor :data, :query

  def title
    "Insight query '#{query}'"
  end

  def execute
    response = chat.ask query
    Command::Result::InsightResponse.new(response.content)
  end

  def undoable?
    false
  end

  def needs_confirmation?
    false
  end

  private
    MAX_CARDS = 100

    def chat
      chat = RubyLLM.chat(model: "chatgpt-4o-latest")
      chat.with_instructions(join_prompts(prompt, domain_model_prompt, current_view_prompt, user_data_injection_prompt, cards_context))
    end

    def prompt
      <<~PROMPT
        You are a helpful assistant that is able to provide answers and insights about the data
        in a general purpose bug/issues tracker called Fizzy.

        ## General rules

        - Try to provide direct answers and insights.
        - If necessary, elaborate on the reasons for your answer.
        - When asking for summaries, try to highlight key outcomes.
        - If you need further details or clarifications, indicate it.
        - When referencing cards or comments, always link them (see rules below).

        ## Linking rules

        - When presenting a given insight, if it clearly derives from a specific card or comment,
          include a link to the card or comment path.
          * Don't add these as standalone links, but referencing words from the insight
        - Markdown link format: [anchor text](/full/path/).
          - Preserve the path exactly as provided (including the leading "/").
        - When showing the card title as the link anchor text, also include #<card id> at the end between parentheses.
      PROMPT
    end

    def cards_context
      cards.limit(MAX_CARDS).collect(&:to_prompt).join("\n")
    end
end
