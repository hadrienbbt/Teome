
struct Plant: Identifiable {
    let id: String
    let variety: Variety

    enum Family: String, CaseIterable, Identifiable {
        case acanthacee
        case apocynacee
        case asclepiadacee
        case asteracee
        case aracee
        case begonia
        case cactus
        case dracaenacee
        case marantacee
        case moracee
        case oxiladacee
        case piperacee
        case strelitziacee
        case urticacee
        
        var id: String { return rawValue }
        
        var varieties: [Variety] {
            return Variety.allCases.filter { $0.family == self }
        }
    }
    
    enum Variety: String, CaseIterable, Identifiable {
        case alocasia
        case anthurium
        case cactus
        case caladium
        case calathea
        case ceropegia
        case diffenbachia
        case ficus
        case fittonia
        case hoya
        case monstera
        case oxalis
        case peperomia
        case philodendron
        case pilea
        case sanseveria
        case scindapsus
        case senecio
        case strelitzia
        case syngonium
        case wightii
        
        var id: String { return rawValue }
        
        var family: Family {
            switch self {
            case .alocasia, .anthurium, .caladium, .diffenbachia, .monstera, .philodendron, .scindapsus, .syngonium: return .aracee
            
            case .cactus: return .cactus
            case .calathea: return .marantacee
            case .ceropegia: return .asclepiadacee
            case .ficus: return .moracee
            case .fittonia: return .acanthacee
            case .hoya: return .apocynacee
            case .oxalis: return .oxiladacee
            case .peperomia: return .piperacee
            case .pilea: return .urticacee
            case .sanseveria: return .dracaenacee
            case .senecio: return .asteracee
            case .strelitzia: return .strelitziacee
            case .wightii: return .begonia
            }
        }
    }
}

