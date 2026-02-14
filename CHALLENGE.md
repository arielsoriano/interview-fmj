# City Events Explorer – Flutter Coding Challenge (DRIBBA)

Welcome!  
This challenge is designed to take **~6–8 focused hours**.

---

## 1. Objective

Build a small **Flutter** application that allows users to:

1. **Browse upcoming events** in a city (data loaded from a local JSON file).  
2. **Search & filter** events by category and date range.  
3. **Save favourite events** locally so they persist across app restarts.

Pixel-perfect UI is *not* required — we will evaluate your **code structure, reasoning, and implementation quality**.

---

## 2. Functional Requirements

| ID   | Description                                                                                   |
|------|-----------------------------------------------------------------------------------------------|
| FR-1 | Load event data from the local file `assets/data/events.json`.                                |
| FR-2 | Display a scrollable list of events with pagination or lazy loading.                          |
| FR-3 | Show an event-detail screen: image, full description, map preview, and “Add to favourites”.   |
| FR-4 | Store favourite events locally (persistence required).                                         |

---

## 3. Non-Functional Requirements

* **Architecture** – Use a layered approach (e.g. Clean Architecture, MVVM, BLoC). Explain your decisions in `docs/ADR-001.md`.  
* **State management** – Any modern solution is acceptable (e.g., Riverpod, BLoC, Provider…).  
* **Testing** – At least one **unit test** and one **widget test** for non-trivial logic.  
* **Linting & formatting** – Include a project-level `analysis_options.yaml`. CI should fail on lint errors.  
* **Git hygiene** – Use small, meaningful commits (ideally following Conventional Commits).  
* **Documentation** – This README should include setup instructions, and you must explain your technical decisions.  

---

## 4. Suggested Repository Structure

```
📦 city_events_explorer/
├── assets/
│   └── data/
│       └── events.json             # The source of event data
├── docs/
│   └── ADR-001.md                  # Architecture Decision Record (mandatory)
├── lib/
│   └── src/
│       ├── data/
│       ├── domain/
│       ├── presentation/
│       └── app.dart
├── test/
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

---

## 5. Deliverables

* A Git repository we can clone (public or private link).  
* **Unmodified commit history** (don’t squash after finishing).  
* `docs/ADR-001.md` must contain:
  - Your architectural approach (text + optional diagram).
  - Rationale for state-management & DI choices.
  - Trade-offs you considered.

---

## 6. Evaluation Rubric

| Area                                | Weight | What we look for                                                                 |
|-------------------------------------|--------|----------------------------------------------------------------------------------|
| Architecture & separation of concerns | 35 %  | Clear layers, testability, good structure.                                       |
| Code quality & readability          | 25 %  | Idiomatic Dart, meaningful naming, null safety, widget decomposition.           |
| Reasoning & documentation           | 20 %  | ADR quality, commit messages, README clarity.                                   |
| Testing strategy                    | 10 %  | Appropriate test coverage of UI and logic.                                      |
| Polish / extra effort               | 10 %  | CI setup, animations, caching strategy, offline UX, etc.                        |

---

## 7. Event Data Format

The app must load event data from:

```
assets/data/events.json
```

### Sample `events.json` content

```json
[
  {
    "id": "1",
    "title": "Sunset Yoga in the Park",
    "description": "Enjoy a relaxing yoga session at sunset.",
    "category": "Health & Wellness",
    "startDate": "2025-07-01T18:00:00Z",
    "endDate": "2025-07-01T19:00:00Z",
    "imageUrl": "https://picsum.photos/seed/yoga/600/300",
    "location": {
      "name": "Central Park",
      "lat": 40.785091,
      "lng": -73.968285
    }
  }
]
```

> Use Flutter’s `rootBundle.loadString` to load and parse the JSON file.

---

## 10. License

This challenge is for evaluation purposes only. You may reuse the structure under the MIT license unless otherwise stated.

---

Have fun and code with purpose!  
We look forward to reviewing your work at Dribba!.
