//
//  Common.swift
//  my-sibgu
//
//  Created by art-off on 29.11.2020.
//

import Foundation

class Common {
//    static func getDay1() -> GroupDay {
//        let lesson1 = GroupLesson(
//            time: "11:30 - 13:00",
//            subgroups: [
//                GroupSubgroup(subject: "Физическая культура что-то там еще", type: "(практика)", professors: ["Добрая бабуля", "Богданов Константив Васильевич(?)", "Охорзин Дед Почти", "Богданов Константив Васильевич(?)"], professorsId: [1, 2, 3, 4], place: "СПОРТЗАЛ")
//            ]
//        )
//
//        let lesson2 = GroupLesson(
//            time: "13:30 - 15:00",
//            subgroups: [
//                GroupSubgroup(subject: "Объектно-ориентированное программирование", type: "(лекция)", professors: ["Добрая бабуля"], professorsId: [1, 2, 3, 4], place: "Л 319"),
//                GroupSubgroup(subject: "Ахритектура вычислительных систем", type: "(лекция)", professors: ["Богданов Константив Васильевич(?)"], professorsId: [1, 2, 3, 4], place: "Л 315")
//            ]
//        )
//
//        let lesson3 = GroupLesson(
//            time: "15:10 - 16:40",
//            subgroups: [
//                GroupSubgroup(subject: "Вычислительная математика", type: "(практика)", professors: ["Охорзин Дед Почти"], professorsId: [1, 2, 3, 4], place: "Н 304")
//            ]
//        )
//
//        let lesson4 = GroupLesson(
//            time: "16:50 - 18:20",
//            subgroups: [
//                GroupSubgroup(subject: "Вычислительная математика", type: "(практика)", professors: ["Охорзин Дед Почти"], professorsId: [1, 2, 3, 4], place: "Н 304")
//            ]
//        )
//
//        let day = GroupDay(lessons: [lesson1, lesson2, lesson3, lesson4])
//        return day
//    }
//
//    static func getDay2() -> GroupDay {
//        let lesson1 = GroupLesson(
//            time: "11:30 - 13:00",
//            subgroups: [
//                GroupSubgroup(subject: "Физическая культура что-то там еще", type: "(практика)", professors: ["Добрая бабуля", "Богданов Константив Васильевич(?)", "Охорзин Дед Почти", "Богданов Константив Васильевич(?)"], professorsId: [1, 2, 3, 4], place: "СПОРТЗАЛ")
//            ]
//        )
//
//        let lesson4 = GroupLesson(
//            time: "16:50 - 18:20",
//            subgroups: [
//                GroupSubgroup(subject: "Вычислительная математика", type: "(практика)", professors: ["Охорзин Дед Почти"], professorsId: [1, 2, 3, 4], place: "Н 304")
//            ]
//        )
//
//        let day = GroupDay(lessons: [lesson1, lesson4])
//        return day
//    }
//
//    static func getDay3() -> GroupDay {
//        let lesson1 = GroupLesson(
//            time: "33:33 - 33:00",
//            subgroups: [
//                GroupSubgroup(subject: "Физическая культура что-то там еще", type: "(практика)", professors: ["Добрая бабуля", "Богданов Константив Васильевич(?)", "Охорзин Дед Почти", "Богданов Константив Васильевич(?)"], professorsId: [1, 2, 3, 4], place: "СПОРТЗАЛ")
//            ]
//        )
//
//        let lesson4 = GroupLesson(
//            time: "16:33 - 18:33",
//            subgroups: [
//                GroupSubgroup(subject: "Вычислительная математика", type: "(практика)", professors: ["Охорзин Дед Почти"], professorsId: [1, 2, 3, 4], place: "Н 304")
//            ]
//        )
//
//        let day = GroupDay(lessons: [lesson1, lesson4])
//        return day
//    }
//
//    static func getWeek1() -> GroupWeek {
//        let week = GroupWeek(days: [
//            getDay1(), nil, nil, getDay2(), getDay3(), nil
//        ])
//        return week
//    }
//
//    static func getWeek2() -> GroupWeek {
//        let week = GroupWeek(days: [
//            nil, nil, getDay3(), getDay1(), getDay1(), nil
//        ])
//        return week
//    }
    
    
    static func getGroupDay0() -> RGroupDay {
        
        let lesson1 = RGroupLesson()
        lesson1.time = "11:30 - 13:00"
        
        let subgroup11 = RGroupSubgroup()
        subgroup11.number = 0
        subgroup11.subject = "Физическая культура что-то там еще"
        subgroup11.type = 0
        subgroup11.professor = "Какой-то профессор"
        subgroup11.place = "3"
        lesson1.subgroups.append(subgroup11)
        
        
        let lesson2 = RGroupLesson()
        lesson2.time = "13:30 - 15:00"
        
        let subgroup21 = RGroupSubgroup()
        subgroup21.number = 1
        subgroup21.subject = "Объектно-ориентированное программирование"
        subgroup21.type = 1
        subgroup21.professor = "Какой-то еап"
        subgroup21.place = "Vtcnjnnn"
        lesson2.subgroups.append(subgroup21)
        let subgroup22 = RGroupSubgroup()
        subgroup22.number = 2
        subgroup22.subject = "Ахритектура вычислительных систем"
        subgroup22.type = 1
        subgroup22.professor = "7"
        subgroup22.place = "54"
        lesson2.subgroups.append(subgroup22)
        
        let lesson3 = RGroupLesson()
        lesson3.time = "14:99 - 23:32"
        
        let subgroup31 = RGroupSubgroup()
        subgroup31.number = 0
        subgroup31.subject = "Вычислительная математика"
        subgroup31.type = 0
        subgroup31.professor = "4"
        subgroup31.place = "38"
        lesson3.subgroups.append(subgroup31)
        
        
        let lesson4 = RGroupLesson()
        lesson4.time = "15:10 - 16:40"
        
        let subgroup41 = RGroupSubgroup()
        subgroup41.number = 0
        subgroup41.subject = "Вычислительная математика"
        subgroup41.type = 1
        subgroup41.professor = "4"
        subgroup41.place = "90"
        lesson4.subgroups.append(subgroup41)

        
        let day = RGroupDay()
        day.number = 0
        day.lessons.append(lesson1)
        day.lessons.append(lesson2)
        day.lessons.append(lesson3)
        day.lessons.append(lesson4)
        return day
    }
    
    static func getGroupDay1() -> RGroupDay {
        
        let lesson1 = RGroupLesson()
        lesson1.time = "11:30 - 13:00"
        
        let subgroup11 = RGroupSubgroup()
        subgroup11.number = 0
        subgroup11.subject = "Физическая культура что-то там еще"
        subgroup11.type = 0
        subgroup11.professor = "1"
        subgroup11.place = "22"
        lesson1.subgroups.append(subgroup11)
        
        
        let lesson4 = RGroupLesson()
        lesson4.time = "15:10 - 16:40"
        
        let subgroup41 = RGroupSubgroup()
        subgroup41.number = 0
        subgroup41.subject = "Вычислительная математика"
        subgroup41.type = 2
        subgroup41.professor = "4"
        subgroup41.place = "33"
        lesson4.subgroups.append(subgroup41)
        
        
        let day = RGroupDay()
        day.number = 1
        day.lessons.append(lesson1)
        day.lessons.append(lesson4)
        return day
    }
    
    static func getGroupDay2() -> RGroupDay {
        
        let lesson1 = RGroupLesson()
        lesson1.time = "33:33 - 33:00"
        
        let subgroup11 = RGroupSubgroup()
        subgroup11.number = 0
        subgroup11.subject = "Физическая культура что-то там еще"
        subgroup11.type = 1
        subgroup11.professor = "1"
        subgroup11.place = "3"
        lesson1.subgroups.append(subgroup11)
        
        
        let lesson3 = RGroupLesson()
        lesson3.time = "15:10 - 16:40"
        
        let subgroup31 = RGroupSubgroup()
        subgroup31.number = 0
        subgroup31.subject = "Вычислительная математика"
        subgroup31.type = 1
        subgroup31.professor = "4"
        subgroup31.place = "2"
        lesson3.subgroups.append(subgroup31)
        
        
        let day = RGroupDay()
        day.number = 2
        day.lessons.append(lesson1)
        day.lessons.append(lesson3)
        return day
    }
    
    static func getGroupWeek1() -> RGroupWeek {
        let week = RGroupWeek()
        week.number = 0
        week.days.append(getGroupDay0())
        week.days.append(getGroupDay2())

        return week
    }
    
    static func getGroupWeek2() -> RGroupWeek {
        let week = RGroupWeek()
        week.number = 1
        week.days.append(getGroupDay1())
        week.days.append(getGroupDay2())

        return week
    }
    
    static func getGroupWeek3() -> RGroupWeek {
        let week = RGroupWeek()
        week.number = 1
        week.days.append(getGroupDay0())
        week.days.append(getGroupDay1())
        week.days.append(getGroupDay2())

        return week
    }
    
    static func getGroupTimetable0() -> GroupTimetable {
        let week1 = getGroupWeek1()
        let week2 = getGroupWeek2()
        let timetabel = RGroupTimetable()
        timetabel.weeks.append(week1)
        timetabel.weeks.append(week2)
        
        return Translator.shared.convertGroupTimetable(from: timetabel, groupName: "utn9")
    }
    
    
    static func addGroupTimetable1() {
        
        let timetable = RGroupTimetable()
        timetable.groupId = 1

        timetable.weeks.append(getGroupWeek1())
        timetable.weeks.append(getGroupWeek2())
        
        DataManager.shared.write(groupTimetable: timetable)
    }
    
    static func addGroupTimetable5() {
        let timetable = RGroupTimetable()
        timetable.groupId = 5

        timetable.weeks.append(getGroupWeek1())
        timetable.weeks.append(getGroupWeek3())
        
        DataManager.shared.write(groupTimetable: timetable)
    }
    
    
    
    static func addGroups() {
        
        var groups = [RGroup]()
        
        for i in 0...100 {
            let group = RGroup()
            group.id = i
            group.name = "\(i)nameGroup"
            group.email = "\(i)emailGroup"
            // group.leaderName = "\(i)lnGroup"
            // group.leaderEmail = nil
            // group.leaderPhone = "\(i)lpGroup"
            
            groups.append(group)
        }
        
        DataManager.shared.write(groups: groups)
    }
    
    
    static func getEvents() -> [Event] {
        return [
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "21! Новогодний флешмоб Университета Решетнёва радует красноярцев и гостей города\n\nДо 8 января 2021 года в вечернее время на фасаде главного корпуса Университета Решетнёва будет сиять заветное новогоднее число – 21. Так оригинально вуз решил поздравить жителей и гостей Красноярска.\n\nПоддерживая тренды по новогоднему декорированию Ленинского района, ректор Эдхам Шукриевич Акбулатов предложил идею использовать в определенном порядке включенные окна учебных аудиторий здания университета, [рандомная ссылка на гуголь](https://www.google.com) панорамно выходящего на главный проспект правого берега. И теперь знаменитая ракета решетневцев не только [рандомная ссылка на вк](https://www.vk.com) символично, но и, образно говоря, наглядно стремится вперед, в XXI век, вместе со всем Красноярском.\n\nПриглашаем всех на вечернюю прогулку по проспекту им. газеты «Красноярский рабочий» до площади им. Котельникова, чтобы полюбоваться на новогодний флешмоб Университета Решетнёва.", author: "test1", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "Звание «Почетный доктор Сибирского государственного университета науки и технологий имени академика М. Ф. Решетнева» присвоено Олегу Бартунову\n\nРешением Ученого совета СибГУ им. М.Ф. Решетнева звания почетного доктора университета удостоился Бартунов Олег Сергеевич, генеральный директор компании «Постгрес Профессиональный», г. Москва, научный сотрудник Государственного астрономического института им. П. К. Штернберга при Московском государственном университете им. М. В. Ломоносова (ГАИШ МГУ).\n\nОлег Бартунов работает в сфере систем управления базами данных (СУБД). Он более двадцати лет участвует в разработке свободной СУБД PostgreSQL.\nСУБД PostgreSQL используется в учебном процессе в Институте информатики и телекоммуникаций СибГУ им. М. Ф. Решетнева с 2000 г. На основе этой СУБД создана информационная система управления вузом «Паллада».\nПодробнее - https://www.sibsau.ru/content/1973\n\n[Внезаптное предложение зарегаться](https://google.com)\n\n#ReshU #sibgu #Reshetnev_University #МинобрнаукиРоссии", author: "test2", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "Внимание, внимание!\n\nВсем студентам СибГУ, Чемпионам и будущим победителям!\n\nОбъявляем открытие отборочного турнира в сборные для ВКСЛ🤠\n\nСобирай команду из 5 человек для Доты или КСки, или же участвуй в одиночных дисциплинах и вперед к победе! 👾\n\nВесь турнир будет проходить 9 и 10 января🕹\n\nПобедители турнира попадут в сборную СибГУ и будут защищать честь нашего могучего ВУЗа на региональном уровне!💯💯\n\n⛳В программу входят:\n\n🦴DotA 2(командный)\n🦴CS:GO(командный)\n🦴Hearthstone(одиночный)\n🦴Clash Royale(одиночный)\n🦴Starcraft II (одиночный)\n\n✅Ссылка на регистрацию:\nhttps://vk.cc/bWNi8K\n\n❓По всем вопросам обращаться к организатору: Артуру Шумбасову\n\n#ВКСЛ #Esports #SibSUEsport #Киберспорт #КиберспортСибГУ #DotA2 #CSGO #HS #ClashRoyale #Starcraft2", author: "test3", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "Подвели итоги внутривузовской олимпиады по маркетингу среди студентов СибГУ им. М.Ф. Решетнева - https://sibsau.ru/content/1968/\n\nПодвели итоги региональной научно-практической конференции «Современные проблемы и тенденции развития экономики и управления бизнес-процессами» - https://sibsau.ru/content/1969/\n\n#sibgu #ReshU #ReshetnevUniversity #МинобрнаукиРоссии", author: "test4", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfa;lsdkjfsldkj flsdkfj sldfjasakjsdflkjsldkfj sldkfj", author: "test5", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfasldfjasl;dkfsldkjf lsdkfj lskdfjlskdfjlakjsdflkjsldkfj sldkfj", author: "test6", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfa;lsdkjfsldkj flsdkfj sldfjasl;dkfsldkjf lsdkfj lskdfjlskdfjlakjsdflkjsldkfj sldkfj", author: "test1", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkjdfjlakjsdflkjsldkfj sldkfj", author: "test2", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj", author: "test3", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "sldkfj", author: "test4", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfa;lsdkjfsldkj flsdkfj sldfjasakjsdflkjsldkfj sldkfj", author: "test5", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfasldfjasl;dkfsldkjf lsdkfj lskdfjlskdfjlakjsdflkjsldkfj sldkfj", author: "test6", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfa;lsdkjfsldkj flsdkfj sldfjasl;dkfsldkjf lsdkfj lskdfjlskdfjlakjsdflkjsldkfj sldkfj", author: "test1", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkjdfjlakjsdflkjsldkfj sldkfj", author: "test2", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj", author: "test3", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "sldkfj", author: "test4", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfa;lsdkjfsldkj flsdkfj sldfjasakjsdflkjsldkfj sldkfj", author: "test5", links: []),
            Event(name: "Название", logoUrl: URL(string: "google.com")!, postTest: "lk lsdkfj lskdjf lskdjfsdlfkj sldkfj lsdkfj lsdkfasldfjasl;dkfsldkjf lsdkfj lskdfjlskdfjlakjsdflkjsldkfj sldkfj", author: "test6", links: []),
        ]
    }
}
