require 'spec_helper'

describe Databasedotcom::Isolated::Scope do
  before(:each) do
    @scope = Databasedotcom::Isolated::Scope.new({
      client: double('client', {
        list_sobjects: %w{Contact Account}
      })
    })
  end

  it "Initializes as new anonimous subclass rather than an instance" do
    expect(@scope).to be_kind_of Class
  end

  context "#perform" do
    before(:each) do
      # @scope.client.should_receive('list_sobject').and_return(%w{Contact Account})
    end

    it "performs the code on the block" do
      @scope.perform do
        'DO SOMETHING'
      end
    end

    it "search for constants on the database.com client" do
      @scope.client.should_receive(:list_sobjects)
      expect{
        @scope.perform do
          UnknownContact
        end
      }.to raise_error NameError
    end

    it "materializes known database.com classes" do
      @scope.client.should_receive(:materialize).with('Contact').and_return(Class.new)

      @scope.perform do
        Contact.new
      end
    end

    it "doesn't  pollutes known namespaces with constants" do
      @scope.client.should_receive(:materialize).with('Contact').and_return(Class.new)

      @scope.perform do
        Contact.new
      end

      expect(defined?( Contact )).to be_nil
      expect(defined?( ::Contact )).to be_nil
      expect(defined?( Databasedotcom::Isolated::Scope::Contact )).to be_nil
      expect(defined?( Databasedotcom::Isolated::Scope.new::Contact )).to be_nil
    end


    it "properly pass outside variables into the block" do
      variable = 1

      @scope.perform do
        expect(variable).to be 1
      end
    end
  end
end
