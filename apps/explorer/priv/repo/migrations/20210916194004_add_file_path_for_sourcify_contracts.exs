defmodule Explorer.Repo.Migrations.AddFilePathForSourcifyContracts do
  use Ecto.Migration

  def change do
    alter table(:smart_contracts) do
      add(:file_path, :string, null: true)
    end
  end
end
