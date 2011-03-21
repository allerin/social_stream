module SocialStream
  module TestHelpers
    module Controllers
      # Post for PostsController
      def model_class
        @model_class ||=
          described_class.to_s.sub!("Controller", "").singularize.constantize
      end

      # :post for PostsController
      def model_sym
        @model_sym ||=
          model_class.to_s.underscore.to_sym
      end

      # Factory.attributes_for(:post) for PostsController
      def model_attributes
        @model_attributes ||=
          Factory.attributes_for(model_sym)
      end

      def attributes
        { model_sym => model_attributes }
      end

      # Post.count
      def model_count
        model_class.count
      end

      def model_assigned_to tie
        model_attributes[:_activity_tie_id] = tie.id
      end

      shared_examples_for "Allow Creating" do
        it "should create" do
          count = model_count
          post :create, attributes

          resource = assigns(model_sym)

          model_count.should eq(count + 1)
          assert resource.valid?
          response.should redirect_to(resource)
        end
      end

      shared_examples_for "Deny Creating" do
        it "should not create" do
          count = model_count
          begin
            post :create, attributes
          rescue CanCan::AccessDenied
          end

          resource = assigns(model_sym)

          model_count.should eq(count)
          resource.should be_new_record
        end
      end
    end
  end
end
