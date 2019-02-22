//
//  Lecture.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/19/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

// XMLDecoder cannot use [Lecture].self so we have to wrap the lectues in Lectures. This is probably a bug in parsing the root node.
struct Lectures: Decodable {
    var lectures: [Lecture]
    
    enum CodingKeys: String, CodingKey {
        case lectures = "row"
    }
}

@objc class Lecture: NSManagedObject, Entity {
    
    /*
     <row>
        <stp_sp_nr>950396293</stp_sp_nr>
        <stp_lv_nr>90049615</stp_lv_nr>
        <stp_sp_titel>Practical course - Program optimization with LLVM (IN0012, IN2106, IN4236)</stp_sp_titel>
        <dauer_info>6</dauer_info>
        <stp_sp_sst>6</stp_sp_sst>
        <stp_lv_art_name>Praktikum</stp_lv_art_name>
        <stp_lv_art_kurz>PR</stp_lv_art_kurz>
        <sj_name>2018/19</sj_name>
        <semester>W</semester>
        <semester_name>Wintersemester 2018/19</semester_name>
        <semester_id>18W</semester_id>
        <org_nr_betreut>15427</org_nr_betreut>
        <org_name_betreut>Informatik 2 - Lehrstuhl für Sprachen und Beschreibungsstrukturen in der Informatik (Prof. Seidl)</org_name_betreut>
        <org_kennung_betreut>TUINI02</org_kennung_betreut>
        <vortragende_mitwirkende>Seidl H [L], Petter M</vortragende_mitwirkende>
     </row>
 */
    
    /*
     @NSManaged public var dauer_info: String?
     @NSManaged public var org_kennung_betreut: String?
     @NSManaged public var org_name_betreut: String?
     @NSManaged public var org_nr_betreut: String?
     @NSManaged public var semester: String?
     @NSManaged public var semester_id: String?
     @NSManaged public var semester_name: String?
     @NSManaged public var sj_name: String?
     @NSManaged public var stp_lv_art_kurz: String?
     @NSManaged public var stp_lv_art_name: String?
     @NSManaged public var stp_lv_nr: String?
     @NSManaged public var stp_sp_nr: String?
     @NSManaged public var stp_sp_sst: String?
     @NSManaged public var stp_sp_title: String?
     @NSManaged public var vortragende_mitwirkendew: String?
 */
    
    enum CodingKeys: String, CodingKey {
        case stp_sp_nr = "stp_sp_nr"
        case stp_lv_nr = "stp_lv_nr"
        case stp_sp_titel = "stp_sp_titel"
        case dauer_info = "dauer_info"
        case stp_sp_sst = "stp_sp_sst"
        case stp_lv_art_name = "stp_lv_art_name"
        case stp_lv_art_kurz = "stp_lv_art_kurz"
        case sj_name = "sj_name"
        case semester = "semester"
        case semester_name = "semester_name"
        case semester_id = "semester_id"
        case org_nr_betreut = "org_nr_betreut"
        case org_name_betreut = "org_name_betreut"
        case org_kennung_betreut = "org_kennung_betreut"
        case vortragende_mitwirkende = "vortragende_mitwirkende"
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dauer_info = try container.decode(String.self, forKey: .dauer_info)
        let org_kennung_betreut = try container.decode(String.self, forKey: .org_kennung_betreut)
        let org_name_betreut = try container.decode(String.self, forKey: .org_name_betreut)
        let org_nr_betreut = try container.decode(String.self, forKey: .org_nr_betreut)
        let semester = try container.decode(String.self, forKey: .semester)
        let semester_id = try container.decode(String.self, forKey: .semester_id)
        let semester_name = try container.decode(String.self, forKey: .semester_name)
        let sj_name = try container.decode(String.self, forKey: .sj_name)
        let stp_lv_art_kurz = try container.decode(String.self, forKey: .stp_lv_art_kurz)
        let stp_lv_art_name = try container.decode(String.self, forKey: .stp_lv_art_name)
        let stp_lv_nr = try container.decode(String.self, forKey: .stp_lv_nr)
        let stp_sp_nr = try container.decode(String.self, forKey: .stp_sp_nr)
        let stp_sp_sst = try container.decode(String.self, forKey: .stp_sp_sst)
        let stp_sp_title = try container.decode(String.self, forKey: .stp_sp_titel)
        let vortragende_mitwirkendew = try container.decode(String.self, forKey: .vortragende_mitwirkende)
        
        self.init(entity: Lecture.entity(), insertInto: context)
        self.dauer_info = dauer_info
        self.org_kennung_betreut = org_kennung_betreut
        self.org_name_betreut = org_name_betreut
        self.org_nr_betreut = org_nr_betreut
        self.semester = semester
        self.semester_id = semester_id
        self.semester_name = semester_name
        self.sj_name = sj_name
        self.stp_lv_art_kurz = stp_lv_art_kurz
        self.stp_lv_art_name = stp_lv_art_name
        self.stp_lv_nr = stp_lv_nr
        self.stp_sp_nr = stp_sp_nr
        self.stp_sp_sst = stp_sp_sst
        self.stp_sp_title = stp_sp_title
        self.vortragende_mitwirkendew = vortragende_mitwirkendew
    }

}