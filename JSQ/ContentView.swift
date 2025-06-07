import SwiftUI

/**
 * 计算器主视图
 * 提供完整的计算器功能界面
 */
struct ContentView: View {
    @State private var display = "0"
    @State private var previousNumber: Double = 0
    @State private var currentOperation: Operation? = nil
    @State private var isTypingNumber = false
    
    /**
     * 计算操作枚举
     */
    enum Operation {
        case add, subtract, multiply, divide
        
        /**
         * 执行计算操作
         * @param a: 第一个操作数
         * @param b: 第二个操作数
         * @return: 计算结果
         */
        func calculate(_ a: Double, _ b: Double) -> Double {
            switch self {
            case .add:
                return a + b
            case .subtract:
                return a - b
            case .multiply:
                return a * b
            case .divide:
                return b != 0 ? a / b : 0
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // 显示屏
            HStack {
                Spacer()
                Text(display)
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            // 按钮区域
            VStack(spacing: 12) {
                // 第一行：AC, +/-, %, ÷
                HStack(spacing: 12) {
                    CalculatorButton(title: "AC", color: .gray, action: clearAll)
                    CalculatorButton(title: "+/-", color: .gray, action: toggleSign)
                    CalculatorButton(title: "%", color: .gray, action: percentage)
                    CalculatorButton(title: "÷", color: .orange, action: { setOperation(.divide) })
                }
                
                // 第二行：7, 8, 9, ×
                HStack(spacing: 12) {
                    CalculatorButton(title: "7", color: .darkGray, action: { numberPressed("7") })
                    CalculatorButton(title: "8", color: .darkGray, action: { numberPressed("8") })
                    CalculatorButton(title: "9", color: .darkGray, action: { numberPressed("9") })
                    CalculatorButton(title: "×", color: .orange, action: { setOperation(.multiply) })
                }
                
                // 第三行：4, 5, 6, -
                HStack(spacing: 12) {
                    CalculatorButton(title: "4", color: .darkGray, action: { numberPressed("4") })
                    CalculatorButton(title: "5", color: .darkGray, action: { numberPressed("5") })
                    CalculatorButton(title: "6", color: .darkGray, action: { numberPressed("6") })
                    CalculatorButton(title: "-", color: .orange, action: { setOperation(.subtract) })
                }
                
                // 第四行：1, 2, 3, +
                HStack(spacing: 12) {
                    CalculatorButton(title: "1", color: .darkGray, action: { numberPressed("1") })
                    CalculatorButton(title: "2", color: .darkGray, action: { numberPressed("2") })
                    CalculatorButton(title: "3", color: .darkGray, action: { numberPressed("3") })
                    CalculatorButton(title: "+", color: .orange, action: { setOperation(.add) })
                }
                
                // 第五行：0, ., =
                HStack(spacing: 12) {
                    CalculatorButton(title: "0", color: .darkGray, action: { numberPressed("0") }, isWide: true)
                    CalculatorButton(title: ".", color: .darkGray, action: decimalPressed)
                    CalculatorButton(title: "=", color: .orange, action: calculate)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color.black)
        .ignoresSafeArea()
    }
    
    // MARK: - 计算器功能方法
    
    /**
     * 处理数字按钮点击
     * @param number: 被点击的数字字符串
     */
    private func numberPressed(_ number: String) {
        if isTypingNumber {
            if display.count < 9 {
                display += number
            }
        } else {
            display = number
            isTypingNumber = true
        }
    }
    
    /**
     * 处理小数点按钮点击
     */
    private func decimalPressed() {
        if !display.contains(".") {
            if isTypingNumber {
                display += "."
            } else {
                display = "0."
                isTypingNumber = true
            }
        }
    }
    
    /**
     * 设置计算操作
     * @param operation: 要设置的操作类型
     */
    private func setOperation(_ operation: Operation) {
        if currentOperation != nil && isTypingNumber {
            calculate()
        }
        
        previousNumber = Double(display) ?? 0
        currentOperation = operation
        isTypingNumber = false
    }
    
    /**
     * 执行计算
     */
    private func calculate() {
        guard let operation = currentOperation else { return }
        
        let currentNumber = Double(display) ?? 0
        let result = operation.calculate(previousNumber, currentNumber)
        
        display = formatResult(result)
        currentOperation = nil
        isTypingNumber = false
    }
    
    /**
     * 清除所有数据
     */
    private func clearAll() {
        display = "0"
        previousNumber = 0
        currentOperation = nil
        isTypingNumber = false
    }
    
    /**
     * 切换正负号
     */
    private func toggleSign() {
        if let number = Double(display) {
            display = formatResult(-number)
        }
    }
    
    /**
     * 计算百分比
     */
    private func percentage() {
        if let number = Double(display) {
            display = formatResult(number / 100)
        }
    }
    
    /**
     * 格式化计算结果
     * @param result: 要格式化的数字
     * @return: 格式化后的字符串
     */
    private func formatResult(_ result: Double) -> String {
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", result)
        } else {
            return String(result)
        }
    }
}

/**
 * 计算器按钮组件
 */
struct CalculatorButton: View {
    let title: String
    let color: ButtonColor
    let action: () -> Void
    let isWide: Bool
    
    /**
     * 初始化计算器按钮
     * @param title: 按钮标题
     * @param color: 按钮颜色
     * @param action: 点击动作
     * @param isWide: 是否为宽按钮
     */
    init(title: String, color: ButtonColor, action: @escaping () -> Void, isWide: Bool = false) {
        self.title = title
        self.color = color
        self.action = action
        self.isWide = isWide
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(color == .orange ? .white : .black)
                .frame(width: isWide ? 168 : 78, height: 78)
                .background(color.backgroundColor)
                .clipShape(Capsule())
        }
    }
}

/**
 * 按钮颜色枚举
 */
enum ButtonColor {
    case gray, darkGray, orange
    
    var backgroundColor: Color {
        switch self {
        case .gray:
            return Color(red: 0.65, green: 0.65, blue: 0.65)
        case .darkGray:
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        case .orange:
            return Color.orange
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
