require_relative 'acceptance_helper'

describe %q{
  In order to manage repos
  As an User
  I want to create an account
} do

  before(:each) do
    User.delete_all
  end

  describe 'I make POST request to signup' do
    before { signup_with_id('senthil') }

    context 'when successful' do
      it 'User is created if unique' do
        User.count.should == 1
      end

      it 'JSON is returned with success status' do
        last_response.body.should == 'success'
      end
    end

    context 'when failed' do
      before { signup_with_id('senthil') }

      it 'User is not created if already exists' do
        User.count.should == 1
      end

      it 'JSON is returned with failure status' do
        last_response.body.should == 'failed'
      end
    end
  end

  def signup_with_id(id)
    post('/users', { :params => { :github_id => id } })
  end
end
