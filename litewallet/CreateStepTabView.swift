import SwiftUI

struct CreateStepTabView: View {
	let stepViews: [CreateStepView]

	init(stepViews: [CreateStepView]) {
		self.stepViews = stepViews
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			TabView {
				ForEach(0 ..< stepViews.count, id: \.self) { index in
					ZStack {
						stepViews[index]
					}
					.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
				}
				.padding(.all, 10)
			}
			.tabViewStyle(PageTabViewStyle())
		}
	}
}

#Preview {
	CreateStepTabView(stepViews: [CreateStepView]())
}
