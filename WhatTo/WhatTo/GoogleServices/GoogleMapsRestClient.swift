import Alamofire


class GoogleMapsRestClient {
    
    static let GMS_API_KEY = "AIzaSyDLQ3zm0BPJDDNsYxNDMr4PEjpg7t4eLLw"
    static let GEOCODING_API_KEY = "AIzaSyCyPjx8P653F_j8G-eazG-uHB9qCoq9N28"
    static let DIRECTION_API_KEY = "AIzaSyAdHWDDlZHsjcQ57azkCIFir7I3GhoN0wg"
    static let GMSPLACES_API_KEY = "AIzaSyDdUvFXxhLMpili_tspnE2QK7wkAHAoL3c"

    
    /*
    static let GMS_API_KEY = "AIzaSyCCOokOQ_nQamDAdVOWhMtRMOKZixlFMns"
    static let GEOCODING_API_KEY = "AIzaSyCCOokOQ_nQamDAdVOWhMtRMOKZixlFMns"
    static let DIRECTION_API_KEY = "AIzaSyCCOokOQ_nQamDAdVOWhMtRMOKZixlFMns"*/

    
    static private func getResponse(url: String, params: [String:String], complete: @escaping (_ response: JSON?) -> Void) {
        
        Alamofire.request(url, method: .get, parameters: params).validate().responseJSON { response in
            
            if let json = response.result.value {
                complete(JSON(json))
            } else {
                complete(nil)
            }
            
            debugPrint(response)
            
        }
        
    }
    
    static func geocodeAddress(params: [String:String], complete: @escaping (_ response: JSON?) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json"
        getResponse(url: url, params: params) { (response) in
            complete(response)
        }
    }
    
    static func directions(params: [String:String], complete: @escaping (_ response: JSON?) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/directions/json"
        getResponse(url: url, params: params) { (response) in
            complete(response)
        }
    }
    
    static func placeName(params: [String:String], complete: @escaping (_ response: JSON?) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/place/details/json"
        getResponse(url: url, params: params) { (response) in
            complete(response)
        }
    }
    
    static func nearPlace(params: [String:String], complete: @escaping (_ response: JSON?) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        getResponse(url: url, params: params) { (response) in
            complete(response)
        }
    }
    
    static func autoComplateText(params: [String:String], complete: @escaping (_ response: JSON?) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        getResponse(url: url, params: params) { (response) in
            complete(response)
        }
    }

}
