//
//  Game.swift
//  DurakGame
//
//  Created by Дима Носко on 16.06.21.
//

import Foundation

protocol GameCompatible {
    var players: [Player] { get set }
}

struct Game: GameCompatible {
    var players: [Player]
}

extension Game {

    func defineFirstAttackingPlayer(players: [Player]) -> Player? {
        var minTrumpCard: Card? //для записи минимального козыря
        var currentPlayer: Player? //игрока с наименьшим козырем
        
        for player in players { //бежим по игрокам
            //получаем козыря у каждого
            guard let handTrump = player.hand?.filter({ card in
                card.isTrump == true
            }) else { continue }
            
            guard handTrump.count > 0 else { continue }
            //пробегаемся по картам игрока и находим наименьший козырь
            for card in handTrump {
                if minTrumpCard == nil {
                    minTrumpCard = handTrump.first!
                    currentPlayer = player
                    continue
                }
                //когда пробежим по всем будет храниться наименьший
                if card.value.rawValue < minTrumpCard!.value.rawValue{
                    minTrumpCard = card
                    currentPlayer = player
                }
            }
        }
        return currentPlayer ?? nil
    }
}
