require_relative "../spec_helper"

describe "additional_view_directories plugin" do 
  it "supports additional view directories" do
    app(:bare) do
      plugin :render, :views=>'spec/views'
      plugin :additional_view_directories, ['spec/views/about', 'spec/views/additional']
      route do |r|
        find_template(:template=>r.remaining_path)[:path]
      end
    end

    # Only in :views, returns :views
    body('a').must_equal File.expand_path('spec/views/a.erb')

    # In both :views and additional, returns :views
    body('_test').must_equal File.expand_path('spec/views/_test.erb')

    # In both additional, returns first additional
    body('only').must_equal File.expand_path('spec/views/about/only.erb')

    # Only in first additional, returns first additional
    body('only_about').must_equal File.expand_path('spec/views/about/only_about.erb')

    # Only in second additional, returns second additional
    body('only_add').must_equal File.expand_path('spec/views/additional/only_add.erb')

    # Not in any, returns :views
    body('bogus').must_equal File.expand_path('spec/views/bogus.erb')
  end
end
