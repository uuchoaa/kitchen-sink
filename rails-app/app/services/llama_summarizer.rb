# frozen_string_literal: true

class LlamaSummarizer
  LLAMA_CLI_PATH = 'llama-cli' # Installed via brew, available in PATH
  MODEL_PATH = '/Users/dev/workspace/llama-models/mistral-7b-instruct-v0.2.Q4_K_M.gguf'
  
  def self.summarize(conversation_data)
    new(conversation_data).summarize
  end
  
  def initialize(conversation_data)
    @conversation_data = conversation_data
  end
  
  def summarize
    prompt = build_prompt
    
    puts "🤖 Calling llama.cpp to summarize conversation..."
    
    # Chama llama-cli via subprocess (redireciona stderr para /dev/null para limpar logs)
    output = `#{LLAMA_CLI_PATH} \
      -m #{MODEL_PATH} \
      -p "#{prompt.gsub('"', '\"')}" \
      -n 200 \
      --temp 0.7 \
      -no-cnv \
      --repeat-penalty 1.1 \
      2>/dev/null`
    
    # Extrai apenas a resposta (remove logs e metadados)
    summary = extract_summary(output, prompt)
    
    puts "✅ Summary generated: #{summary[0..100]}..."
    
    summary
  rescue => e
    puts "❌ Error generating summary: #{e.message}"
    "Error: Unable to generate summary - #{e.message}"
  end
  
  private
  
  def build_prompt
    contact_name = @conversation_data[:contact][:name] || 'the contact'
    messages_text = @conversation_data[:messages].map do |msg|
      "#{msg[:sender]}: #{msg[:text]}"
    end.join("\n")
    
    <<~PROMPT
      Summarize this LinkedIn recruiting conversation between #{contact_name} and the candidate.
      
      Focus on:
      - Job opportunity details
      - Company and role
      - Requirements mentioned
      - Salary/compensation if discussed
      - Next steps or action items
      
      Messages:
      #{messages_text}
      
      Provide a concise, professional summary in 2-3 sentences.
    PROMPT
  end
  
  def extract_summary(output, prompt)
    # Remove o prompt da saída (às vezes llama-cli ecoa o prompt)
    cleaned = output.gsub(prompt, '').strip
    
    # Remove linhas de log/debug do llama.cpp
    lines = cleaned.split("\n")
    
    # Pega apenas linhas que parecem ser a resposta do modelo
    # (ignora linhas que começam com print_info, load, common_, etc)
    response_lines = lines.reject do |line|
      line.match?(/^(print_info|load|common_|llama_|ggml_|system_info|sampler|generate|main:|build:|==|>|\s*-|\t|\.{3,})/i) ||
      line.strip.empty?
    end
    
    # Junta e limpa
    response = response_lines.join("\n").strip
    
    # Se ainda tiver muito texto (mais que o esperado), pega só os últimos parágrafos
    if response.length > 1000
      # Pega tudo após o último "Provide a concise" ou similares
      if response =~ /(Provide a concise.*?\n\n)(.+)/m
        response = $2.strip
      else
        # Fallback: pega últimas 500 chars
        response = response[-500..-1]
      end
    end
    
    # Remove marcadores de fim se existirem
    response.gsub(/\[end of text\].*$/im, '').strip
  end
end

