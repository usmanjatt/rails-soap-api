class AvsService < ApplicationService

  attr_reader :params

    def initialize(params)
      @params = params
    end
  
    def call
        @service_info = {
            "rtav:GroupID": 3,
            "rtav:Password": ENV['rt_avs_password'],
            "rtav:ServiceKey":  ENV['rt_avs_service_key'],
            "rtav:Usercode":  ENV['rt_avs_usercode'],
            "rtav:Username":  ENV['rt_avs_username']
          }

        @account_info = {
            "rtav:AccountNumber": @params[:account_number],
            "rtav:AccountType": @params[:account_type],
            "rtav:BranchCode": @params[:branch_code],
            "rtav:CellNo": @params[:cell_no],
            "rtav:Email": @params[:email],
            "rtav:FullName": @params[:full_name],
            "rtav:IDNumber": @params[:id_number],
            "rtav:Initials": @params[:initials],
            "rtav:UniqueIdentifier": @params[:unique_identifier]
        }

        client = Savon.client(
            wsdl: ENV['rt_avs_endpoint'],
            log: true,
            pretty_print_xml: true,
            env_namespace: :soap,
            namespace_identifier: :tem,
            namespaces: { "xmlns:soap" => ENV['rt_avs_soap_env'],
                        "xmlns:tem" => ENV['rt_avs_tem'],
                        "xmlns:rtav" => ENV['rt_avs_rtav'] },
            use_wsa_headers: true,            
            soap_version: 2
      )
      
        response = client.call(:verify_account, message: {'tem:request' => { 'rtav:AccountInfo' => @account_info, 'rtav:ServiceInfo' => @service_info }})

        response
      end
  end