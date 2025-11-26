# frozen_string_literal: true

class Components::TablePreview < ComponentPreview
  preview :simple,
    name: "Tabela Simples",
    description: "Tabela básica com dados estáticos. Use o método column para definir as colunas, passando o header e um bloco que define como extrair o valor de cada row.",
    code: %(data = [
  { name: "João Silva", email: "joao@example.com", role: "Admin" },
  { name: "Maria Santos", email: "maria@example.com", role: "User" },
  { name: "Pedro Costa", email: "pedro@example.com", role: "Manager" }
]

Components::Table.new(data) do |t|
  t.column("Nome") { |row| row[:name] }
  t.column("Email") { |row| row[:email] }
  t.column("Função") { |row| row[:role] }
end) do
    data = [
      { name: "João Silva", email: "joao@example.com", role: "Admin" },
      { name: "Maria Santos", email: "maria@example.com", role: "User" },
      { name: "Pedro Costa", email: "pedro@example.com", role: "Manager" }
    ]

    Components::Table.new(data) do |t|
      t.column("Nome") { |row| row[:name] }
      t.column("Email") { |row| row[:email] }
      t.column("Função") { |row| row[:role] }
    end
  end

  preview :with_formatting,
    name: "Com Formatação",
    description: "Tabela com formatação customizada nas células. Você pode usar Phlex helpers ou HTML dentro dos blocos das colunas para estilizar os valores.",
    code: %(data = [
  { product: "Laptop", price: 3500.00, stock: 15, status: "active" },
  { product: "Mouse", price: 50.00, stock: 0, status: "inactive" },
  { product: "Teclado", price: 250.00, stock: 8, status: "active" }
]

Components::Table.new(data) do |t|
  t.column("Produto") { |row| row[:product] }
  t.column("Preço") { |row| "R$ \#{'%.2f' % row[:price]\}" }
  t.column("Estoque") do |row|
    if row[:stock] > 0
      row[:stock]
    else
      "Esgotado"
    end
  end
  t.column("Status") do |row|
    row[:status] == "active" ? "✓ Ativo" : "✗ Inativo"
  end
end) do
    data = [
      { product: "Laptop", price: 3500.00, stock: 15, status: "active" },
      { product: "Mouse", price: 50.00, stock: 0, status: "inactive" },
      { product: "Teclado", price: 250.00, stock: 8, status: "active" }
    ]

    Components::Table.new(data) do |t|
      t.column("Produto") { |row| row[:product] }
      t.column("Preço") { |row| "R$ #{'%.2f' % row[:price]}" }
      t.column("Estoque") do |row|
        if row[:stock] > 0
          row[:stock]
        else
          "Esgotado"
        end
      end
      t.column("Status") do |row|
        row[:status] == "active" ? "✓ Ativo" : "✗ Inativo"
      end
    end
  end

  preview :empty,
    name: "Tabela Vazia",
    description: "Exemplo de como a tabela se comporta sem dados. Mostra apenas os headers sem linhas no tbody.",
    code: %(Components::Table.new([]) do |t|
  t.column("ID") { |row| row[:id] }
  t.column("Nome") { |row| row[:name] }
  t.column("Criado em") { |row| row[:created_at] }
end) do
    Components::Table.new([]) do |t|
      t.column("ID") { |row| row[:id] }
      t.column("Nome") { |row| row[:name] }
      t.column("Criado em") { |row| row[:created_at] }
    end
  end
end
