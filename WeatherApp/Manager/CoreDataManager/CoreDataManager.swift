//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Darkhan Serkeshev on 27.08.2021.
//

import Foundation
import CoreData

// TODO: 6 - Хранение прогноза погоды и отображение в оффлайн режиме
final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func save() {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func getCurrentWeather() -> WeatherModel? {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<ForecastEntity> = ForecastEntity.fetchRequest()
        
        let forecasts = try? context.fetch(request)

        return forecasts?.map( { WeatherModel(weather: $0) } ).last
    }

    func addWeatherCondition(_ weather: WeatherModel) {
        let context = persistentContainer.viewContext
        context.perform {
            let forecastEntity = ForecastEntity(context: context)
            forecastEntity.cityName = weather.name
            forecastEntity.temperature = "\(weather.main.temp)"
            forecastEntity.weatherCondition = "\(weather.weather.first?.id ?? 0)"
            forecastEntity.latitude = "\(weather.coord.lat)"
            forecastEntity.longitude = "\(weather.coord.lon)"
            print("... weather saved \(weather.name)")
        }
        save()
    }

    func deleteWeather(cityName: String? = nil, lat: String? = nil) {
        let context = persistentContainer.viewContext

        if let forecast = find(name: cityName, lat: lat) {
            context.delete(forecast)
            if let name = cityName {
                print("... weather deleted \(name) \(forecast.cityName!)")
            } else if let lat = lat {
                print("... weather deleted \(lat) \(forecast.latitude!)")
            }
        }
        save()
    }

    func find(name: String? = nil, lat: String? = nil) -> ForecastEntity? {
        let context = persistentContainer.viewContext
        let requestResult: NSFetchRequest<ForecastEntity> = ForecastEntity.fetchRequest()
        if let name = name {
            requestResult.predicate = NSPredicate(format: "cityName == %@", name)
        } else if let lat = lat {
            requestResult.predicate = NSPredicate(format: "latitude == %@", lat)
        }

        do {
            let cities = try context.fetch(requestResult)
            if cities.count > 0 { //error
                assert(cities.count == 1, "Duplicates were found!!!")
                return cities[0]
            }
        } catch {
            print(error)
        }

        return nil
    }
    
    func clearDatabase() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ForecastEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
}
