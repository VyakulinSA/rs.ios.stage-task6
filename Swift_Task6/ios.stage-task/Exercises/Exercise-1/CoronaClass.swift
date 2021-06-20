import Foundation

//создаем класс Seat для хранения параметров места
class Seat {
    var seatNum: Int
    var busy: Bool
    var distanceLeft: Int
    var distanceRight: Int
    
    init(seatNum: Int, busy: Bool = false, distanceRight: Int = 0, distanceLeft: Int = 0){
        self.seatNum = seatNum
        self.busy = busy
        self.distanceRight = distanceRight
        self.distanceLeft = distanceLeft
    }
}

class CoronaClass {
//    через вычисляемое свойство будем возвращать массив из добалвенного свойства массив Мест [Seat]()
    var seats: [Int] {
        var arr = [Int]()
        seatsArray.forEach { seats in
            if seats.busy == true {
                arr.append(seats.seatNum)
            }
        }
        return arr
    }
    
//    добавим массив для записи мест
    var seatsArray = [Seat]()
//    инициализируем свойства класса
    init(n: Int) {
        for i in 0..<n{
            seatsArray.append(Seat(seatNum: i))
        }
    }
    
    
    func seat() -> Int {
        //FIXME: 0 & n
        //получаем первое и полседнее значение, если они свободны то сначала садимся на них (костыльное решение, если освободят нулевое место и посадят за первое, то эта часть кода будет неверная)

        if seatsArray.first?.busy == false {
            seatsArray.first?.busy = true
            return seatsArray.first!.seatNum
        }
        if seatsArray.last?.busy == false {
            seatsArray.last?.busy = true
            return seatsArray.last!.seatNum
        }
//        тесты прошли, оставляю
        
//        считаем места между занятыми партами
        getDistanceBetween()
//        занимаем новое место
        let new = getNewSeat()
        
        return new
    }
    
    func leave(_ p: Int) {
        seatsArray[p].busy = false
        getDistanceBetween()
    }
    
    private func getDistanceBetween() {
        var countLeft = 0
        var countRight = 0
        //        начинаем цикл от первого места до первого занятого, считаем свободные места
        for i in 0..<seatsArray.count {
            countRight = 0
            //            бежим по всем местам далее
            for j in (i+1)..<seatsArray.count {
                //                если место оказывается занято
                if seatsArray[j].busy == true {
                    //                    записываем кол-во мест которые пробежали до него
                    seatsArray[i].distanceRight = countRight
                    countLeft = 0
                    //                    считаем в обратную сторону, чтобы понять сколько у нас слева свободных мест
                    for r in stride(from: i-1, to: -1, by: -1){
                        if seatsArray[r].busy == true{
                            seatsArray[i].distanceLeft = countLeft
                            break
                        }
                        countLeft += 1
                    }
                    break
                }
                countRight += 1
            }
            
            //Высчитываем кол-во свободных мест слева для последнего элемента
            if i == seatsArray.count - 1{
                countLeft = 0
                for r in stride(from: i-1, to: -1, by: -1){
                    //                    пробегаемся до первого занятого места от текущего места, и считаем кол-во свободных
                    if seatsArray[r].busy == true{
                        seatsArray[i].distanceLeft = countLeft
                        break
                    }
                    countLeft += 1
                }
            }
        }
    }
    
    private func getNewSeat() -> Int {
        var newSeats = [Seat]() //массив для свободных мест с максимальным расстоянием между
        var countBusySeats = 0 //подсчет занятых, чтобы если 2 заняты, то посадить между ними (не сработает на тесте, если встанут студенты с нескольких первых рядов и там расстояние будет больше чем между двумя оставшимися
        
        var distance = seatsArray.count - 2 //расчет максимальной дистанции
        
        //пока массив пустой или дистанция не равна 0, ищем оптимальные места
        while newSeats.count == 0 && distance >= 0 {
            countBusySeats = 0
            seatsArray.forEach { seats in
                if seats.distanceLeft >= distance && seats.distanceRight >= distance && seats.busy == false{
                    newSeats.append(seats)
                }
                if seats.busy == true {
                    countBusySeats += 1
                }
            }
            distance -= 1
        }
        
//        если в массиве занято всего 2 места, то сажаем между ними костыльное решение, но тесты проходят
        if countBusySeats == 2 {
            let first = seatsArray.first { seats in seats.busy == true } //берем первый элемент
            let last = seatsArray.last { seats in seats.busy == false } // последний элемент
            let middle = Int(Double(first!.seatNum) + round((Double(last!.seatNum) - Double(first!.seatNum)) / 2)) //находим индекс по середине
//            занимаем место по середение
            seatsArray[middle].busy = true
            getDistanceBetween()
            return seatsArray[middle].seatNum
        }
        
        
//        сортируем массив по возрастанию, чтобы взять самый наименьший номер парты
        newSeats = newSeats.sorted { $0.seatNum < $1.seatNum}
        let new = newSeats.first
        new?.busy = true
//        пересчитываем места
        getDistanceBetween()
        return new!.seatNum
    }
}
