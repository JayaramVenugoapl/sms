require 'rails_helper'

RSpec.describe 'SmS API', type: :request do
  
  describe "POST /outbound/sms" do
    describe "Condition - Invalid Authentication are passed" do
      context "With valid username, invalid auth_id" do
        before do
          post '/outbound/sms', headers: {"Authorization" =>  "#{env_with_auth("email", "password")}"}
        end

        it 'returns Invalid credentials response' do
          expect(json).not_to be_empty
          expect(json["error"]).to eq("Invalid credentials")
        end

        it 'returns status code 403' do
          expect(response).to have_http_status(403)
        end
      end
    end

    describe "Condition - Valid Authentication are passed" do
      before do
        @account = Account.create!({auth_id: "20S0KPNOIM", username: "azr1"})
        @phone_number = PhoneNumber.create!({number: "4924195509198", account_id: @account.id})
        post '/outbound/sms', params: params, headers: {"Authorization" =>  "#{env_with_auth("azr1", "20S0KPNOIM")}"}
      end

      context "Parameter Missing" do
        context "From missing" do
          let(:params) {{"to": "1234567890", "text": "stop1"}}
          
          it "return parameter missing" do
            expect(json["error"]).to eq("from is missing")
          end

          it 'returns status code 400' do
            expect(response).to have_http_status(400)
          end
        end

        context "To missing" do
          let(:params) {{"from": "1234567890", "text": "stop1"}}
          
          it "return parameter missing" do
            expect(json["error"]).to eq("to is missing")
          end

          it 'returns status code 400' do
            expect(response).to have_http_status(400)
          end
        end

         context "Text missing" do
          let(:params) {{"to": "1234567890", "from": "stop1"}}
          
          it "return parameter missing" do
            expect(json["error"]).to eq("text is missing")
          end

          it 'returns status code 400' do
            expect(response).to have_http_status(400)
          end
        end
        
      end

      context "Validate character count" do
        context "Validate from and to length 6 to 16 digits" do
          context "from length below 6" do
            let(:params) {{"to": "1234567890", "text": "stop1", "from": "1234"}}
          
            it "return parameter missing" do
              expect(json["error"]).to eq("from is invalid")
            end

            it 'returns status code 400' do
              expect(response).to have_http_status(400)
            end
          end

          context "from length above 16 digits" do
            let(:params) {{"to": "1234567890", "text": "stop1", "from": "12345678901234567890"}}
          
            it "return parameter missing" do
              expect(json["error"]).to eq("from is invalid")
            end

            it 'returns status code 400' do
              expect(response).to have_http_status(400)
            end
          end
          
          context "to length below 6" do
            let(:params) {{"from": "1234567890", "text": "stop1", "to": "12345"}}
          
            it "return parameter missing" do
              expect(json["error"]).to eq("to is invalid")
            end

            it 'returns status code 400' do
              expect(response).to have_http_status(400)
            end
          end

          context "to length above 16 digits" do
            let(:params) {{"from": "1234567890", "text": "stop1", "to": "12345678901234567890"}}
          
            it "return parameter missing" do
              expect(json["error"]).to eq("to is invalid")
            end

            it 'returns status code 400' do
              expect(response).to have_http_status(400)
            end
          end
          
        end

        context "Validate text length 1 to 120 digits" do
          context "text length below 1" do
            let(:params) {{"to": "1234567890", "text": "", "from": "123456789"}}
          
            it "return parameter missing" do
              expect(json["error"]).to eq("text is invalid")
            end

            it 'returns status code 400' do
              expect(response).to have_http_status(400)
            end
          end

          context "text length above 120 character" do
            let(:params) {{"to": "1234567890", "text": "a"*121, "from": "123456789"}}
          
            it "return parameter missing" do
              expect(json["error"]).to eq("text is invalid")
            end

            it 'returns status code 400' do
              expect(response).to have_http_status(400)
            end
          end
          
        end

      end

      context "Validate to parmameter not found in DB" do
        context "To missing" do
          let(:params) {{"from": "1234567890", "text": "stop1", "to": "12345677890"}}
          
          it "return parameter not found" do
            expect(json["error"]).to eq("from parameter not found")
          end

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end
        end
      end

      context "Validate Success Response" do
        context "Message as hello world!" do
          let(:params) {{"from": @phone_number.number, "text": "hello world!", "to": "1234567890"}}
          
          it "return message success" do
            expect(json["message"]).to eq("inbound sms ok")
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end
  

  private
  def env_with_auth(email, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(email, password)
  end
end