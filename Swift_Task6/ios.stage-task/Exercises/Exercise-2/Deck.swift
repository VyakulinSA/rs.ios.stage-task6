import Foundation

protocol DeckBaseCompatible: Codable {
    var cards: [Card] {get set}
    var type: DeckType {get}
    var total: Int {get}
    var trump: Suit? {get}
}

enum DeckType:Int, CaseIterable, Codable {
    case deck36 = 36
}

struct Deck: DeckBaseCompatible {

    //MARK: - Properties

    var cards = [Card]()
    var type: DeckType
    var trump: Suit?

    var total:Int {
        return type.rawValue
    }
}

extension Deck {

    init(with type: DeckType) {
        self.type = type
        //при инициализации создаем колоду
        self.cards = createDeck(suits: Suit.allCases, values: Value.allCases)
    }

    public mutating func createDeck(suits:[Suit], values:[Value]) -> [Card] {
        var cards = [Card]() //массив для складывания карт
        //пробегаемся по мастям и номиналам, складываем в колоду
        for suit in suits {
            for value in values {
                let card = Card(suit: suit, value: value)
                cards.append(card)
            }
        }
        return cards
    }

    public mutating func shuffle() {
        //перемешиваем добавляя во множество (каждый раз разный замес будет, иногда одинаковый, но это удача)
        let shuffleSet = Set(self.cards)
        //возвращаем обратно
        self.cards = Array(shuffleSet)
    }

    public mutating func defineTrump() {
        //FIXME: если где то будет косяк с перетасовкой, то перенести например в инициализацию, чтобы по отдельности и здесь повторно не вызывалось
        shuffle() //возможно не надо перед определением перемешивать, на всякий случай дописал
        guard let trump = self.cards.last else {return} //достаем последнюю карту, это козырь
        setTrumpCards(for: trump.suit) //вызываем метод сохранения\установки козыря для всех карт и козыря игры
    }

    public mutating func initialCardsDealForPlayers(players: [Player]) {
        var countCardsForPlayers = players.count * 6 //определяем кол-во карт для раздачи
        guard countCardsForPlayers < self.total else { return }
        //пока не останется карт для раздачи
        while countCardsForPlayers != 0 {
            //раздаем каждому игроку по одной карте
            for player in players {
                let cardForPlayer = self.cards.removeLast() //берем сверху
                if player.hand != nil { //у игрока может не быть совсем карт на руках, поэтому первоначально проверяяем и создаем hand
                    player.hand?.append(cardForPlayer)
                }else {
                    var hand = [Card]()
                    hand.append(cardForPlayer)
                    player.hand = hand
                }
                
                countCardsForPlayers -= 1
            }
        }
        
    }

    public mutating func setTrumpCards(for suit:Suit) {
        self.trump = suit //сохраняем в свойство - козырь
        for index in self.cards.indices { //перебираем все карты по индексам, и устанавливаем признак козыря
            if self.cards[index].suit == suit{
                self.cards[index].isTrump = true
            }
        }
    }
}

