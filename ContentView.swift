import SwiftUI

// MARK: - Models

struct TaylorAction: Identifiable {
    let id = UUID()
    let name: String
    let points: Int
}

struct ActivityItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let points: Int
    let date: Date

    init(
        id: UUID = UUID(),
        name: String,
        points: Int,
        date: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.points = points
        self.date = date
    }
}


// MARK: - Main View

struct ContentView: View {

    // MARK: Saved Data

    @AppStorage("taylorScore")
    private var score = 75

    @AppStorage("taylorActivityHistory")
    private var savedActivityHistory = ""

    // MARK: Activity

    @State private var recentActivity: [ActivityItem] = []

    // MARK: Sheet

    @State private var activeSheet: TaylorSheet?

    // MARK: Custom Behavior

    @State private var customBehaviorName = ""
    @State private var customPoints = 1

    // MARK: Taylor Animation

    @State private var reaction: TaylorReaction = .normal
    @State private var jumpOffset: CGFloat = 0
    @State private var characterScale: CGFloat = 1.0

    enum TaylorReaction {
        case normal
        case happy
        case sad
    }

    enum TaylorSheet: String, Identifiable {
        case commendations
        case incidents
        case customCommendation
        case customIncident

        var id: String {
            rawValue
        }
    }


    // MARK: - Positive Behaviors

    private let commendations: [TaylorAction] = [

        TaylorAction(
            name: "Forehead Kiss",
            points: 3
        ),

        TaylorAction(
            name: "Random \"I Love You\"",
            points: 3
        ),

        TaylorAction(
            name: "Brings Katelin Coffee",
            points: 4
        ),

        TaylorAction(
            name: "Brings You Flowers",
            points: 5
        ),

        TaylorAction(
            name: "Brings Home a Treat",
            points: 5
        ),

        TaylorAction(
            name: "Cooks Dinner",
            points: 8
        ),

        TaylorAction(
            name: "Brings You a Snack",
            points: 5
        ),

        TaylorAction(
            name: "Unprompted Compliment",
            points: 4
        ),

        TaylorAction(
            name: "Unprompted Cuddle",
            points: 3
        ),

        TaylorAction(
            name: "Does a Chore Without Being Asked",
            points: 7
        ),

        TaylorAction(
            name: "Remembers Something Katelin Mentioned",
            points: 6
        ),

        TaylorAction(
            name: "Thoughtful Surprise",
            points: 8
        ),

        TaylorAction(
            name: "Plans a Date Without Assistance",
            points: 10
        ),

        TaylorAction(
            name: "Unprompted Foot Rub",
            points: 10
        ),

        TaylorAction(
            name: "Excellent Emotional Support",
            points: 8
        ),

        TaylorAction(
            name: "Takes a Good Picture of Katelin",
            points: 5
        ),

        TaylorAction(
            name: "Takes Multiple Good Pictures Without Complaining",
            points: 8
        ),

        TaylorAction(
            name: "Handles an Annoying Errand",
            points: 6
        ),

        TaylorAction(
            name: "Admits Katelin Was Right",
            points: 10
        ),

        TaylorAction(
            name: "Apologizes Without Being Prompted",
            points: 8
        ),

        TaylorAction(
            name: "Makes Katelin Laugh When Annoyed",
            points: 6
        ),

        TaylorAction(
            name: "Exceptional Boyfriend Behavior",
            points: 15
        )
    ]


    // MARK: - Negative Behaviors

    private let incidents: [TaylorAction] = [

        TaylorAction(
            name: "Deez Nuts Joke",
            points: -3
        ),

        TaylorAction(
            name: "\"That's What She Said\" Joke",
            points: -3
        ),

        TaylorAction(
            name: "Cheating Joke",
            points: -5
        ),

        TaylorAction(
            name: "Katelin Says Something and Taylor Simply Does Not Respond",
            points: -2
        ),

        TaylorAction(
            name: "Was Clearly Not Listening",
            points: -5
        ),

        TaylorAction(
            name: "Phone Crimes During Quality Time",
            points: -4
        ),

        TaylorAction(
            name: "Excessive Phone Scrolling",
            points: -3
        ),

        TaylorAction(
            name: "Steals the Blanket",
            points: -4
        ),

        TaylorAction(
            name: "Falls Asleep During Movie Katelin Picked",
            points: -3
        ),

        TaylorAction(
            name: "Says It'll Be an Early Night, Stays Out Late",
            points: -8
        ),

        TaylorAction(
            name: "Fails to Provide ETA",
            points: -4
        ),

        TaylorAction(
            name: "Unnecessary Devil's Advocate Behavior",
            points: -5
        ),

        TaylorAction(
            name: "Weaponized Incompetence",
            points: -7
        ),

        TaylorAction(
            name: "Leaves Mess for Future Taylor",
            points: -4
        ),

        TaylorAction(
            name: "Repeated Deez Nuts Offense",
            points: -7
        ),

        TaylorAction(
            name: "Makes Same Joke After Being Told It Wasn't Funny",
            points: -6
        ),

        TaylorAction(
            name: "Fake Apology / Sorry You Feel That Way",
            points: -10
        ),

        TaylorAction(
            name: "Disturbing the Peace",
            points: -5
        ),

        TaylorAction(
            name: "General Boyfriend Misconduct",
            points: -5
        ),

        TaylorAction(
            name: "Boyfriend Felony",
            points: -25
        )
    ]


    // MARK: - Status

    private var status: String {

        switch score {

        case 90...100:
            return "👑 ELITE BOYFRIEND"

        case 75...89:
            return "💚 GOOD STANDING"

        case 60...74:
            return "⚠️ UNDER REVIEW"

        case 40...59:
            return "📋 PROBATION"

        default:
            return "🚔 BOYFRIEND JAIL"
        }
    }


    // MARK: - Management Message

    private var managementMessage: String {

        switch score {

        case 90...100:
            return "Shareholders remain extremely pleased."

        case 75...89:
            return "No corrective action required."

        case 60...74:
            return "Performance has declined this quarter."

        case 40...59:
            return "Management has identified several areas for improvement."

        default:
            return "Privileges suspended pending forehead-kiss remediation."
        }
    }


    // MARK: - Taylor Image

    private var normalTaylorImage: String {

        switch score {

        case 90...100:
            return "TaylorElite"

        case 75...89:
            return "TaylorGoodStanding"

        case 60...74:
            return "TaylorUnderReview"

        case 40...59:
            return "TaylorProbation"

        default:
            return "TaylorJail"
        }
    }


    private var displayedTaylorImage: String {

        switch reaction {

        case .normal:
            return normalTaylorImage

        case .happy:

            if score >= 90 {
                return "TaylorElite"
            }

            return "TaylorGoodStanding"

        case .sad:

            if score < 40 {
                return "TaylorJail"
            }

            return "TaylorProbation"
        }
    }


    // MARK: - Main Screen

    var body: some View {

        ScrollView {

            VStack(spacing: 16) {

                // TITLE

                Text("TAYLOR TRACKER")
                    .font(.largeTitle)
                    .fontWeight(.black)

                Text(
                    "Official Boyfriend Performance Management System"
                )
                .font(.caption)
                .foregroundStyle(.secondary)


                // TINY TAYLOR

                Image(displayedTaylorImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .offset(y: jumpOffset)
                    .scaleEffect(characterScale)
                    .animation(
                        .spring(
                            response: 0.28,
                            dampingFraction: 0.48
                        ),
                        value: jumpOffset
                    )
                    .animation(
                        .spring(
                            response: 0.30,
                            dampingFraction: 0.55
                        ),
                        value: characterScale
                    )


                // SCORE

                Text("\(score)")
                    .font(
                        .system(
                            size: 64,
                            weight: .bold,
                            design: .rounded
                        )
                    )

                Text("BOYFRIEND RATING")
                    .font(.caption)
                    .fontWeight(.bold)

                Text(status)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(managementMessage)
                    .font(.subheadline)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)


                // SCORE BAR

                ProgressView(
                    value: Double(score),
                    total: 100
                )
                .padding(.horizontal, 25)


                // COMMEND

                Button {

                    activeSheet = .commendations

                } label: {

                    Text("💚  COMMEND TAYLOR")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)


                // INCIDENT

                Button {

                    activeSheet = .incidents

                } label: {

                    Text("🚨  REPORT INCIDENT")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)


                // RECENT ACTIVITY

                if !recentActivity.isEmpty {

                    Divider()
                        .padding(.vertical, 8)

                    HStack {

                        Text("RECENT ACTIVITY")
                            .font(.headline)

                        Spacer()
                    }


                    ForEach(
                        Array(recentActivity.prefix(8))
                    ) { item in

                        HStack {

                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {

                                Text(item.name)
                                    .fontWeight(.medium)

                                Text(
                                    item.points > 0
                                    ? "Commendation"
                                    : "Incident Report"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(
                                item.points > 0
                                ? "+\(item.points)"
                                : "\(item.points)"
                            )
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                item.points > 0
                                ? Color.green
                                : Color.red
                            )
                        }
                        .padding()
                        .background(
                            Color.secondary.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                        )
                    }
                }
            }
            .padding(30)
        }
        .onAppear {

            loadActivity()
        }
        .sheet(
            item: $activeSheet
        ) { sheet in

            sheetContent(sheet)
        }
    }


    // MARK: - Sheet Router

    @ViewBuilder
    private func sheetContent(
        _ sheet: TaylorSheet
    ) -> some View {

        switch sheet {

        case .commendations:

            actionPicker(
                title: "💚 Commend Taylor",
                subtitle: "Select qualifying boyfriend behavior.",
                actions: commendations,
                isPositive: true
            )

        case .incidents:

            actionPicker(
                title: "🚨 Report Incident",
                subtitle: "Select the applicable violation.",
                actions: incidents,
                isPositive: false
            )

        case .customCommendation:

            customActionSheet(
                isPositive: true
            )

        case .customIncident:

            customActionSheet(
                isPositive: false
            )
        }
    }


    // MARK: - Behavior Picker

    @ViewBuilder
    private func actionPicker(
        title: String,
        subtitle: String,
        actions: [TaylorAction],
        isPositive: Bool
    ) -> some View {

        NavigationStack {

            List {

                Section {

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }


                Section {

                    ForEach(actions) { action in

                        Button {

                            activeSheet = nil

                            logAction(action)

                        } label: {

                            HStack {

                                Text(action.name)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)

                                Spacer()

                                Text(
                                    action.points > 0
                                    ? "+\(action.points)"
                                    : "\(action.points)"
                                )
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    action.points > 0
                                    ? Color.green
                                    : Color.red
                                )
                            }
                        }
                    }
                }


                Section {

                    Button {

                        openCustomSheet(
                            isPositive: isPositive
                        )

                    } label: {

                        Label(
                            isPositive
                            ? "Custom Commendation"
                            : "Custom Incident",
                            systemImage:
                                isPositive
                                ? "plus.circle.fill"
                                : "exclamationmark.circle.fill"
                        )
                        .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle(title)
        }
    }


    // MARK: - Custom Behavior

    private func openCustomSheet(
        isPositive: Bool
    ) {

        activeSheet = nil

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.35
        ) {

            activeSheet =
                isPositive
                ? .customCommendation
                : .customIncident
        }
    }


    @ViewBuilder
    private func customActionSheet(
        isPositive: Bool
    ) -> some View {

        NavigationStack {

            Form {

                Section(
                    isPositive
                    ? "What did Taylor do?"
                    : "Describe the offense"
                ) {

                    TextField(
                        isPositive
                        ? "Commendable behavior"
                        : "Incident description",
                        text: $customBehaviorName
                    )
                }


                Section("Points") {

                    Stepper(
                        value: $customPoints,
                        in: 1...25
                    ) {

                        Text(
                            isPositive
                            ? "+\(customPoints) points"
                            : "-\(customPoints) points"
                        )
                    }
                }


                Section {

                    Button {

                        submitCustomAction(
                            isPositive: isPositive
                        )

                    } label: {

                        Text(
                            isPositive
                            ? "💚 COMMEND TAYLOR"
                            : "🚨 FILE INCIDENT REPORT"
                        )
                        .fontWeight(.bold)
                    }
                    .disabled(
                        customBehaviorName
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                }
            }
            .navigationTitle(
                isPositive
                ? "Custom Commendation"
                : "Custom Incident"
            )
        }
    }


    private func submitCustomAction(
        isPositive: Bool
    ) {

        let cleanedName =
            customBehaviorName
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )


        guard !cleanedName.isEmpty else {
            return
        }


        let action = TaylorAction(
            name: cleanedName,
            points:
                isPositive
                ? customPoints
                : -customPoints
        )


        customBehaviorName = ""
        customPoints = 1
        activeSheet = nil

        logAction(action)
    }


    // MARK: - Log Behavior

    private func logAction(
        _ action: TaylorAction
    ) {

        score = min(
            max(
                score + action.points,
                0
            ),
            100
        )


        recentActivity.insert(
            ActivityItem(
                name: action.name,
                points: action.points
            ),
            at: 0
        )


        saveActivity()


        if action.points > 0 {

            commendAnimation()

        } else {

            condemnAnimation()
        }
    }


    // MARK: - Save Activity

    private func saveActivity() {

        do {

            let data =
                try JSONEncoder()
                    .encode(recentActivity)

            savedActivityHistory =
                data.base64EncodedString()

        } catch {

            print(
                "Could not save Taylor activity: \(error)"
            )
        }
    }


    // MARK: - Load Activity

    private func loadActivity() {

        guard
            !savedActivityHistory.isEmpty,
            let data =
                Data(
                    base64Encoded:
                        savedActivityHistory
                )
        else {
            return
        }


        do {

            recentActivity =
                try JSONDecoder()
                    .decode(
                        [ActivityItem].self,
                        from: data
                    )

        } catch {

            print(
                "Could not load Taylor activity: \(error)"
            )
        }
    }


    // MARK: - Positive Animation

    private func commendAnimation() {

        reaction = .happy


        withAnimation {

            jumpOffset = -55
            characterScale = 1.08
        }


        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.28
        ) {

            withAnimation {

                jumpOffset = 0
                characterScale = 1.0
            }
        }


        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.15
        ) {

            reaction = .normal
        }
    }


    // MARK: - Negative Animation

    private func condemnAnimation() {

        reaction = .sad


        withAnimation {

            jumpOffset = 28
            characterScale = 0.92
        }


        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.25
        ) {

            withAnimation {

                jumpOffset = 0
                characterScale = 1.0
            }


            reaction = .normal
        }
    }
}