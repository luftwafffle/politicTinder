import SwiftUI

private enum Palette {
    static let paper = Color(red: 0.97, green: 0.95, blue: 0.90)
    static let ink = Color(red: 0.21, green: 0.24, blue: 0.22)
    static let wine = Color(red: 0.48, green: 0.19, blue: 0.25)
}

struct Thinker: Identifiable {
    let id: Int
    var name: String { "Деятель №" + String(id) }
    var color: Color {
        [Color(red: 0.68, green: 0.72, blue: 0.63),
         Color(red: 0.75, green: 0.65, blue: 0.57),
         Color(red: 0.62, green: 0.69, blue: 0.73)][(id - 1) % 3]
    }
    static let placeholders = (1...13).map { Thinker(id: $0) }
}

struct ContentView: View {
    @State private var started = false
    @State private var answers: [Bool] = []
    @State private var detail: Thinker?
    private let thinkers = Thinker.placeholders

    var body: some View {
        ZStack {
            Palette.paper.ignoresSafeArea()
            if !started { welcome }
            else if answers.count == thinkers.count { conclusion }
            else { deck }
        }
        .foregroundStyle(Palette.ink)
        .tint(Palette.wine)
        .sheet(item: $detail) { thinker in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        Portrait(thinker: thinker).frame(height: 240).clipShape(RoundedRectangle(cornerRadius: 24))
                        Text(thinker.name).font(.largeTitle.bold())
                        Text("Эпоха и годы жизни").font(.subheadline).foregroundStyle(.secondary)
                        detailSection("Политическая мысль эпохи", "Здесь появится краткое описание представлений о государстве, власти и обществе.")
                        detailSection("Главные идеи", "Здесь будут основные взгляды и тезис, с которым можно согласиться или не согласиться.")
                        detailSection("Об авторе", "Биография и исторический контекст будут добавлены позже.")
                    }.padding(24)
                }
                .background(Palette.paper)
                .navigationTitle("Знакомство с идеями")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Готово") { detail = nil } } }
            }
            .tint(Palette.wine)
        }
    }

    private var welcome: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                eyebrow("ПОЛИТОЛОГИЯ • ЗНАКОМСТВО С ИДЕЯМИ")
                ZStack {
                    RoundedRectangle(cornerRadius: 28).fill(Palette.wine.opacity(0.12))
                        .rotationEffect(.degrees(-7)).padding(16)
                    Portrait(thinker: thinkers[0])
                        .clipShape(RoundedRectangle(cornerRadius: 28)).padding(22)
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 62)).foregroundStyle(Palette.wine, Palette.paper)
                        .offset(x: 95, y: 95)
                }.frame(height: 285).accessibilityHidden(true)
                Text("С кем совпадут твои взгляды?")
                    .font(.system(size: 38, weight: .semibold, design: .serif))
                    .fixedSize(horizontal: false, vertical: true)
                Text("Знакомься с политическими идеями разных эпох — от античности до XX века.")
                    .font(.body).foregroundStyle(.secondary)
                Label("13 карточек · в твоём темпе", systemImage: "rectangle.stack")
                    .font(.subheadline)
                primaryButton("Начать знакомство", icon: "arrow.right") {
                    answers = []
                    started = true
                }
                Text("Учебный прототип. Персонажи и идеи пока заменены заглушками.")
                    .font(.footnote).foregroundStyle(.secondary)
            }.padding(28)
        }
    }

    private var deck: some View {
        let thinker = thinkers[answers.count]
        return ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Знакомство с идеями").font(.headline)
                    Spacer()
                    Text(String(answers.count + 1) + " / " + String(thinkers.count))
                        .font(.subheadline.monospacedDigit()).foregroundStyle(Palette.wine)
                }
                ProgressView(value: Double(answers.count), total: Double(thinkers.count))
                Button { detail = thinker } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        Portrait(thinker: thinker).frame(height: 285).clipped()
                        VStack(alignment: .leading, spacing: 12) {
                            eyebrow("ЭПОХА БУДЕТ ДОБАВЛЕНА")
                            Text(thinker.name).font(.system(size: 30, weight: .semibold, design: .serif))
                            Text("Здесь появится политическая идея, которую тебе предстоит оценить.")
                                .font(.body).foregroundStyle(.secondary)
                            Label("Нажми, чтобы узнать больше", systemImage: "info.circle")
                                .font(.footnote).foregroundStyle(Palette.wine)
                        }.padding(24)
                    }
                    .background(.white.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .overlay(RoundedRectangle(cornerRadius: 28).stroke(Palette.ink.opacity(0.08)))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(thinker.name + ". Открыть информацию")
                HStack(spacing: 12) {
                    choiceButton("Не согласен", icon: "xmark", agrees: false)
                    choiceButton("Согласен", icon: "checkmark", agrees: true)
                }
                Button {
                    if !answers.isEmpty { answers.removeLast() }
                } label: { Label("Предыдущая карточка", systemImage: "arrow.uturn.backward") }
                    .font(.footnote).disabled(answers.isEmpty)
            }.padding(24)
        }
    }

    private var conclusion: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                eyebrow("ЗНАКОМСТВО ЗАВЕРШЕНО")
                Image(systemName: "checkmark.seal")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundStyle(Palette.wine).padding(.top, 35)
                Text("13 встреч. Новые вопросы.")
                    .font(.system(size: 40, weight: .semibold, design: .serif))
                Text("Ты прошёл все карточки. Политическая мысль — это разговор о власти, свободе и обществе, который продолжается через века.")
                    .font(.title3)
                VStack(alignment: .leading, spacing: 12) {
                    Label("Все 13 карточек просмотрены", systemImage: "rectangle.stack.fill")
                    Text("Это конец демонстрации. Когда мы добавим деятелей и их идеи, здесь появится содержательное заключение.")
                        .foregroundStyle(.secondary)
                }.padding(22).frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 22))
                Text("Политическая принадлежность в этой версии не определяется.")
                    .font(.footnote).foregroundStyle(.secondary)
                primaryButton("Пройти ещё раз", icon: "arrow.clockwise") { answers = [] }
                Button("На начальный экран") { started = false; answers = [] }
                    .frame(maxWidth: .infinity)
            }.padding(28)
        }
    }

    private func eyebrow(_ text: String) -> some View {
        Text(text).font(.system(size: 11, weight: .bold)).tracking(1.5)
            .foregroundStyle(Palette.wine)
    }

    private func detailSection(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline)
            Text(text).foregroundStyle(.secondary)
        }
    }

    private func primaryButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack { Text(title); Spacer(); Image(systemName: icon) }
                .font(.headline).padding(20).foregroundStyle(.white)
                .background(Palette.wine, in: RoundedRectangle(cornerRadius: 18))
        }.buttonStyle(.plain)
    }

    private func choiceButton(_ title: String, icon: String, agrees: Bool) -> some View {
        Button {
            guard answers.count < thinkers.count else { return }
            answers.append(agrees)
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon).font(.title2.weight(.semibold))
                Text(title).font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity).padding(.vertical, 18)
            .foregroundStyle(agrees ? Color.white : Palette.wine)
            .background(agrees ? Palette.wine : Palette.wine.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
        }.buttonStyle(.plain)
    }
}

private struct Portrait: View {
    let thinker: Thinker
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                thinker.color
                Circle().fill(.white.opacity(0.22))
                    .frame(width: 225, height: 225).offset(x: 65, y: -45)
                Circle().stroke(.white.opacity(0.25), lineWidth: 1)
                    .frame(width: 280, height: 280).offset(x: -65, y: 55)
                Image(systemName: "person.crop.rectangle.fill")
                    .resizable().scaledToFit().foregroundStyle(Palette.ink.opacity(0.65))
                    .frame(width: geometry.size.width * 0.55)
                VStack {
                    HStack {
                        Text("ПОРТРЕТ / " + String(format: "%02d", thinker.id))
                        Spacer()
                        Image(systemName: "sparkle")
                    }
                    Spacer()
                    Text("ЛИЧНОСТЬ БУДЕТ ДОБАВЛЕНА")
                }.font(.system(size: 10, weight: .semibold)).tracking(2)
                    .padding(22).foregroundStyle(Palette.ink.opacity(0.7))
            }.frame(width: geometry.size.width, height: geometry.size.height).clipped()
        }
    }
}

#Preview {
    ContentView()
}
