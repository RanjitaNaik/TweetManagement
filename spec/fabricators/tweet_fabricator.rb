Fabricator(:tweet) do
  tweet "MyString"
  user { Fabricate(:user) }
end