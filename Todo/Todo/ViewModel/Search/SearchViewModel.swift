//
//  SearchViewModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/10/2023.
//

import Foundation
import CoreData
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [CDRemainder] = []
    private var cancellables: Set<AnyCancellable> = []
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        search()
    }

    func getRemainders(with query: String) -> AnyPublisher<[CDRemainder], Error> {
        let request = CDRemainder.fetch()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.schedule_?.date_, ascending: true)]
        let predicate1 = NSPredicate(format: "title_ CONTAINS[cd] %@", query as CVarArg)
        let predicate2 = NSPredicate(format: "notes_ CONTAINS[cd] %@", query as CVarArg)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])

        return Future { promise in
            do {
                let remainders = try self.context.fetch(request)
                promise(.success(remainders))
            } catch {
                promise(.failure(error))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func search() {
        $searchText
            .map { text in
                      return text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .flatMap { [unowned self] text in
                self.getRemainders(with: text)
                    .replaceError(with: [])
            }
            .removeDuplicates()
            .assign(to: &$results)
//            .sink { [unowned self] result in
//                if !result.isEmpty{
//                    self.results = result
//                    print(results[0].title_)
//                }
//            }.store(in: &cancellables)
//
         
    }
}
