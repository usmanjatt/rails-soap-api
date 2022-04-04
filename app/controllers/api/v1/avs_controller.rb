class Api::V1::AvsController < ApplicationController

    def create
        avs_validation = AvsService.call(params)

        render json: avs_validation
    end

end
