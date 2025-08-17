import UIKit

class ViewController: UIViewController {

    var currentPage = 0
    var responses: [String: String] = [:]

    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    let stackView = UIStackView()
    let nextButton = UIButton(type: .system)
    let prevButton = UIButton(type: .system)

    let totalPages = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupQuestions()
        setupNavigation()
    }

    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(totalPages))
        ])
    }

    func setupQuestions() {
        for page in 0..<totalPages {
            let container = UIStackView()
            container.axis = .vertical
            container.spacing = 15
            container.alignment = .fill
            container.distribution = .fillEqually
            container.translatesAutoresizingMaskIntoConstraints = false

            for q in 1...5 {
                let index = page * 5 + q
                let view = questionView(index)
                container.addArrangedSubview(view)
            }

            stackView.addArrangedSubview(container)
            container.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
    }

    func setupNavigation() {
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = currentPage
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        let navStack = UIStackView(arrangedSubviews: [prevButton, nextButton])
        navStack.axis = .horizontal
        navStack.distribution = .fillEqually
        navStack.spacing = 20
        navStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navStack)

        NSLayoutConstraint.activate([
            navStack.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            navStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            navStack.heightAnchor.constraint(equalToConstant: 40)
        ])

        prevButton.setTitle("Previous", for: .normal)
        nextButton.setTitle("Next", for: .normal)

        prevButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        prevButton.isEnabled = false
    }

    func questionView(_ index: Int) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 5
        container.alignment = .fill

        let questionLabel = UILabel()
        questionLabel.text = "Question \(index)"
        questionLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let input: UIView

        switch index % 5 {
        case 0:
            let textField = UITextField()
            textField.placeholder = "Enter text for Question \(index)"
            textField.borderStyle = .roundedRect
            textField.tag = index
            textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
            input = textField

        case 1:
            let seg = UISegmentedControl(items: ["A", "B", "C"])
            seg.tag = index
            seg.addTarget(self, action: #selector(segChanged(_:)), for: .valueChanged)
            input = seg

        case 2:
            let sliderStack = UIStackView()
            sliderStack.axis = .horizontal
            sliderStack.spacing = 10
            sliderStack.alignment = .center

            let slider = UISlider()
            slider.minimumValue = 0
            slider.maximumValue = 10
            slider.value = 5
            slider.tag = index
            slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)

            let label = UILabel()
            label.text = "Value: 5.0"
            label.widthAnchor.constraint(equalToConstant: 100).isActive = true
            label.tag = 1000 + index

            sliderStack.addArrangedSubview(slider)
            sliderStack.addArrangedSubview(label)

            input = sliderStack

        case 3:
            let stepperStack = UIStackView()
            stepperStack.axis = .horizontal
            stepperStack.spacing = 10
            stepperStack.alignment = .center

            let stepper = UIStepper()
            stepper.minimumValue = 0
            stepper.maximumValue = 20
            stepper.tag = index
            stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)

            let label = UILabel()
            label.text = "Count: 0"
            label.widthAnchor.constraint(equalToConstant: 80).isActive = true
            label.tag = 1000 + index

            stepperStack.addArrangedSubview(stepper)
            stepperStack.addArrangedSubview(label)

            input = stepperStack

        case 4:
            let toggle = UISwitch()
            toggle.tag = index
            toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            input = toggle

        default:
            input = UILabel()
        }

        container.addArrangedSubview(questionLabel)
        container.addArrangedSubview(input)
        return container
    }

    @objc func textFieldChanged(_ sender: UITextField) {
        responses["Q\(sender.tag)"] = sender.text ?? ""
    }

    @objc func segChanged(_ sender: UISegmentedControl) {
        let answer = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
        responses["Q\(sender.tag)"] = answer
    }

    @objc func sliderChanged(_ sender: UISlider) {
        let value = String(format: "%.1f", sender.value)
        responses["Q\(sender.tag)"] = value

        if let label = view.viewWithTag(1000 + sender.tag) as? UILabel {
            label.text = "Value: \(value)"
        }
    }

    @objc func stepperChanged(_ sender: UIStepper) {
        let count = Int(sender.value)
        responses["Q\(sender.tag)"] = "\(count)"

        if let label = view.viewWithTag(1000 + sender.tag) as? UILabel {
            label.text = "Count: \(count)"
        }
    }

    @objc func switchChanged(_ sender: UISwitch) {
        responses["Q\(sender.tag)"] = sender.isOn ? "Yes" : "No"
    }

    @objc func previousTapped() {
        if currentPage > 0 {
            currentPage -= 1
            updatePage()
        }
    }

    @objc func nextTapped() {
        if currentPage < totalPages - 1 {
            currentPage += 1
            updatePage()
        } else {
            showSummary()
        }
    }

    func updatePage() {
        let offsetX = CGFloat(currentPage) * view.frame.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        pageControl.currentPage = currentPage
        prevButton.isEnabled = currentPage > 0
        nextButton.setTitle(currentPage == totalPages - 1 ? "Confirm" : "Next", for: .normal)
    }

    func showSummary() {
        let summaryVC = UIViewController()
        summaryVC.view.backgroundColor = .white
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false

        var text = "Summary of Responses:\n"

        let sortedKeys = responses.keys.sorted {
            let num1 = Int($0.dropFirst()) ?? 0
            let num2 = Int($1.dropFirst()) ?? 0
            return num1 < num2
        }

        for key in sortedKeys {
            if let value = responses[key],
               let number = Int(key.dropFirst()) {
                text += "Question \(number): \(value)\n"
            }
        }

        textView.text = text


        summaryVC.view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: summaryVC.view.topAnchor, constant: 50),
            textView.leadingAnchor.constraint(equalTo: summaryVC.view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: summaryVC.view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: summaryVC.view.bottomAnchor, constant: -100)
        ])

        let submitBtn = UIButton(type: .system)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.addTarget(self, action: #selector(printResponses), for: .touchUpInside)

        summaryVC.view.addSubview(submitBtn)
        NSLayoutConstraint.activate([
            submitBtn.bottomAnchor.constraint(equalTo: summaryVC.view.bottomAnchor, constant: -30),
            submitBtn.centerXAnchor.constraint(equalTo: summaryVC.view.centerXAnchor)
        ])

        present(summaryVC, animated: true)
    }

    @objc func printResponses() {
            print("=== USER RESPONSES ===")
            for (key, value) in responses.sorted(by: { $0.key < $1.key }) {
                print("\(key): \(value)")
            }
        }

}
