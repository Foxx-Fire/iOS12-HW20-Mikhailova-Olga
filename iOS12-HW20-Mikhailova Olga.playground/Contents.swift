import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//MARK: - MTGAPIService

final class MTGAPIService {
    
    private enum EndPointURL {
        enum Paths: String {
            case cards = "/v1/cards"
        }
        static let scheme = "https"
        static let host = "api.magicthegathering.io"
        static let baseURL = "https://api.magicthegathering.io"
    }
    
    private func createURL(paths: EndPointURL.Paths, queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = EndPointURL.scheme
        components.host = EndPointURL.host
        components.path = paths.rawValue
        components.queryItems = queryItems
        
        return components.url
    }
    
    func createRequest(url: URL?) -> URLRequest? {
        guard let url else { return nil }
        var request = URLRequest(url: url)
        return request
    }
    
    func fetchOpt(completion: @escaping(Result<Card, NetworkError>) -> Void) {
        let optURL = createURL(paths: .cards, queryItems: [URLQueryItem(name: "name", value: "Opt")])
        
        guard let requestOpt = createRequest(url: optURL) else { return }
        
        let taskOpt = URLSession.shared.dataTask(with: requestOpt) { data, response, error in
            if error != nil {
                print("Some error")
                completion(.failure(.wrongUrl))
            } else {
                guard let httpResponse = response as? HTTPURLResponse,
                      let data else { return }
                switch httpResponse.statusCode{
                case 200:
                    do {
                        let result = try JSONDecoder().decode(CardCodes.self, from: data)
                        completion(.success(result.cards[0]))
                    } catch {
                        completion(.failure(.decodableError))
                    }
                default:
                    print("default")
                    completion(.failure(.requestError))
                }
            }
        }
        taskOpt.resume()
    }
    
    func fetchBlackLotus(completion: @escaping(Result<Card, NetworkError>) -> Void) {
        
        let blackLotusURL = createURL(paths: .cards, queryItems: [URLQueryItem(name: "name", value: "Black Lotus")] )
        
        guard let requestBlackLotus = createRequest(url: blackLotusURL) else { return }
        
        let taskOpt = URLSession.shared.dataTask(with: requestBlackLotus) { data, response, error in
            if error != nil {
                print("Some error")
                completion(.failure(.wrongUrl))
            } else {
                guard let httpResponse = response as? HTTPURLResponse,
                      let data else { return }
                switch httpResponse.statusCode{
                case 200:
                    do {
                        let result = try JSONDecoder().decode(CardCodes.self, from: data)
                        completion(.success(result.cards[0]))
                    } catch {
                        completion(.failure(.decodableError))
                    }
                default:
                    print("default")
                    completion(.failure(.requestError))
                }
            }
        }
        taskOpt.resume()
    }
}

let dispatchQueueA = DispatchQueue(label: "A", attributes: .concurrent)
let cardsList = MTGAPIService()

dispatchQueueA.sync(flags: .barrier) {
    cardsList.fetchOpt{ result in
        switch result {
        case .success(let card):
            print("Card Opt")
            print("name: \(card.name)")
            print("type: \(card.type)")
            print("types: \(card.types)")
            print("text: \(card.text)")
            print("mana: \(card.manaCost ?? "")")
            print("set: \(card.cardSet)")
            print("foreign name: \(String(describing: card.foreignNames))")
            print("artist: \(card.artist)")
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
}

dispatchQueueA.async {
    for _ in 0 ..< 5 {
        sleep(1)
    }
    cardsList.fetchBlackLotus { result in
        switch result {
        case .success(let card):
            print("Card Black Lotus")
            print("name: \(card.name)")
            print("type: \(card.type)")
            print("types: \(card.types)")
            print("text: \(card.text)")
            print("mana: \(card.manaCost ?? "")")
            print("set: \(card.cardSet)")
            print("foreign name: \(String(describing: card.foreignNames))")
            print("artist: \(card.artist)")
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
}

