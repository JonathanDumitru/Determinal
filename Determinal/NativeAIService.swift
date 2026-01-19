//
//  NativeAIService.swift
//  Determinal
//
//  Created by Jonathan Hines Dumitru on 1/15/26.
//

import Foundation
import NaturalLanguage

// MARK: - Native AI Service (Fully Offline)

/// Native AI service that works completely offline using Apple's frameworks
/// No external models, no internet, no setup required
@Observable
final class NativeAIService: LLMServiceProtocol {
    private var currentTask: Task<Void, Never>?
    private let languageRecognizer = NLLanguageRecognizer()
    private let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType, .lemma])
    
    func generate(prompt: String, modelName: String) async throws -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream { continuation in
            currentTask = Task {
                // Analyze the prompt
                let analysis = analyzePrompt(prompt)
                
                // Generate contextual response
                let response = generateResponse(for: prompt, analysis: analysis)
                
                // Stream the response token by token
                await streamResponse(response, to: continuation)
                
                continuation.finish()
            }
        }
    }
    
    func stopGeneration() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    // MARK: - Prompt Analysis
    
    private struct PromptAnalysis {
        let intent: Intent
        let keywords: [String]
        let entities: [String]
        let language: NLLanguage
        let sentiment: Sentiment
        
        enum Intent {
            case greeting
            case codeGeneration
            case codeExplanation
            case generalQuestion
            case help
            case documentation
            case debugging
            case comparison
            case bestPractices
        }
        
        enum Sentiment {
            case positive, neutral, negative
        }
    }
    
    private func analyzePrompt(_ prompt: String) -> PromptAnalysis {
        // Detect language
        languageRecognizer.processString(prompt)
        let language = languageRecognizer.dominantLanguage ?? .english
        
        // Extract keywords and entities
        tagger.string = prompt
        var keywords: [String] = []
        let entities: [String] = []
        
        tagger.enumerateTags(in: prompt.startIndex..<prompt.endIndex, unit: .word, scheme: .lexicalClass) { tag, range in
            if tag == .noun || tag == .verb {
                keywords.append(String(prompt[range]))
            }
            return true
        }
        
        // Detect intent
        let intent = detectIntent(prompt)
        
        // Simple sentiment analysis
        let sentiment = detectSentiment(prompt)
        
        return PromptAnalysis(
            intent: intent,
            keywords: keywords,
            entities: entities,
            language: language,
            sentiment: sentiment
        )
    }
    
    private func detectIntent(_ prompt: String) -> PromptAnalysis.Intent {
        let lower = prompt.lowercased()
        
        // Greeting
        if lower.contains("hello") || lower.contains("hi") || lower.contains("hey") {
            return .greeting
        }
        
        // Code generation
        if lower.contains("write") || lower.contains("create") || lower.contains("generate") ||
           lower.contains("implement") || lower.contains("build") || lower.contains("make a") {
            return .codeGeneration
        }
        
        // Code explanation
        if lower.contains("explain") || lower.contains("what is") || lower.contains("how does") ||
           lower.contains("why") || lower.contains("understand") {
            return .codeExplanation
        }
        
        // Help/Documentation
        if lower.contains("help") || lower.contains("guide") || lower.contains("tutorial") ||
           lower.contains("how to") || lower.contains("documentation") {
            return .help
        }
        
        // Debugging
        if lower.contains("debug") || lower.contains("error") || lower.contains("fix") ||
           lower.contains("problem") || lower.contains("issue") || lower.contains("bug") {
            return .debugging
        }
        
        // Comparison
        if lower.contains("compare") || lower.contains("difference") || lower.contains("vs") ||
           lower.contains("versus") || lower.contains("better") {
            return .comparison
        }
        
        // Best practices
        if lower.contains("best practice") || lower.contains("should i") || lower.contains("recommended") ||
           lower.contains("standard") || lower.contains("convention") {
            return .bestPractices
        }
        
        return .generalQuestion
    }
    
    private func detectSentiment(_ prompt: String) -> PromptAnalysis.Sentiment {
        let positiveWords = ["great", "good", "excellent", "awesome", "perfect", "love", "thank"]
        let negativeWords = ["bad", "terrible", "awful", "hate", "problem", "issue", "broken"]
        
        let lower = prompt.lowercased()
        let hasPositive = positiveWords.contains { lower.contains($0) }
        let hasNegative = negativeWords.contains { lower.contains($0) }
        
        if hasPositive && !hasNegative {
            return .positive
        } else if hasNegative && !hasPositive {
            return .negative
        }
        return .neutral
    }
    
    // MARK: - Response Generation
    
    private func generateResponse(for prompt: String, analysis: PromptAnalysis) -> String {
        switch analysis.intent {
        case .greeting:
            return generateGreeting(prompt: prompt)
            
        case .codeGeneration:
            return generateCodeResponse(prompt: prompt, keywords: analysis.keywords)
            
        case .codeExplanation:
            return generateExplanation(prompt: prompt, keywords: analysis.keywords)
            
        case .help:
            return generateHelpResponse(prompt: prompt)
            
        case .debugging:
            return generateDebuggingAdvice(prompt: prompt)
            
        case .comparison:
            return generateComparison(prompt: prompt)
            
        case .bestPractices:
            return generateBestPractices(prompt: prompt)
            
        case .generalQuestion:
            return generateGeneralResponse(prompt: prompt, keywords: analysis.keywords)
            
        case .documentation:
            return generateDocumentationResponse(prompt: prompt, keywords: analysis.keywords)
        }
    }
    
    private func generateGreeting(prompt: String) -> String {
        """
        Hello! 👋 I'm Determinal's native AI assistant.
        
        I run completely offline using Apple's Natural Language framework and local knowledge.
        
        I can help you with:
        • Swift and iOS development
        • Code explanations and examples
        • Debugging and problem-solving
        • Best practices and conventions
        • General programming concepts
        
        What would you like to work on today?
        """
    }
    
    private func generateCodeResponse(prompt: String, keywords: [String]) -> String {
        let lower = prompt.lowercased()
        
        // Detect programming language
        if lower.contains("swift") {
            return generateSwiftCode(prompt: prompt)
        } else if lower.contains("python") {
            return generatePythonCode(prompt: prompt)
        } else if lower.contains("javascript") || lower.contains("js") {
            return generateJavaScriptCode(prompt: prompt)
        }
        
        // Default to Swift since this is a Mac app
        return generateSwiftCode(prompt: prompt)
    }
    
    private func generateSwiftCode(prompt: String) -> String {
        let lower = prompt.lowercased()
        
        // Detect specific patterns
        if lower.contains("sort") || lower.contains("array") {
            return """
            Here's a Swift function to sort an array:
            
            ```swift
            // Simple sorting
            let numbers = [3, 1, 4, 1, 5, 9, 2, 6]
            let sorted = numbers.sorted()  // [1, 1, 2, 3, 4, 5, 6, 9]
            
            // Custom sorting
            let sorted = numbers.sorted { $0 > $1 }  // Descending
            
            // Sort in place
            var mutableNumbers = numbers
            mutableNumbers.sort()
            
            // Custom comparator
            struct Person {
                let name: String
                let age: Int
            }
            
            let people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
            let sortedByAge = people.sorted { $0.age < $1.age }
            ```
            
            Key points:
            • sorted() creates a new array
            • sort() modifies the array in place
            • Use closures for custom sorting
            """
        }
        
        if lower.contains("async") || lower.contains("await") {
            return """
            Here's how to use async/await in Swift:
            
            ```swift
            // Basic async function
            func fetchData() async throws -> Data {
                let url = URL(string: "https://api.example.com/data")!
                let (data, _) = try await URLSession.shared.data(from: url)
                return data
            }
            
            // Calling async function
            Task {
                do {
                    let data = try await fetchData()
                    print("Received \\(data.count) bytes")
                } catch {
                    print("Error: \\(error)")
                }
            }
            
            // Multiple concurrent tasks
            async let user = fetchUser()
            async let posts = fetchPosts()
            let (userData, postData) = await (user, posts)
            
            // Task group for dynamic concurrency
            await withTaskGroup(of: Data.self) { group in
                for url in urls {
                    group.addTask {
                        try await fetchData(from: url)
                    }
                }
            }
            ```
            
            Key concepts:
            • async marks a function as asynchronous
            • await suspends execution until result is ready
            • Use Task {} to call async from sync context
            • async let for concurrent execution
            """
        }
        
        // Generic Swift response
        return """
        Here's a basic Swift code example:
        
        ```swift
        import Foundation
        
        // Define a struct
        struct Item {
            let name: String
            var quantity: Int
        }
        
        // Create instances
        var items = [
            Item(name: "Apple", quantity: 5),
            Item(name: "Banana", quantity: 3)
        ]
        
        // Use functional programming
        let total = items.reduce(0) { $0 + $1.quantity }
        print("Total items: \\(total)")
        
        // Filter and map
        let lowStock = items
            .filter { $0.quantity < 5 }
            .map { $0.name }
        ```
        
        For more specific help, describe what you're trying to build!
        """
    }
    
    private func generatePythonCode(prompt: String) -> String {
        """
        Here's a Python code example:
        
        ```python
        # List comprehension
        numbers = [1, 2, 3, 4, 5]
        squares = [x**2 for x in numbers]
        
        # Function definition
        def greet(name: str) -> str:
            return f"Hello, {name}!"
        
        # Class definition
        class Person:
            def __init__(self, name: str, age: int):
                self.name = name
                self.age = age
            
            def introduce(self):
                print(f"I'm {self.name}, {self.age} years old")
        
        # Usage
        person = Person("Alice", 30)
        person.introduce()
        ```
        
        Python emphasizes readability and simplicity!
        """
    }
    
    private func generateJavaScriptCode(prompt: String) -> String {
        """
        Here's a JavaScript code example:
        
        ```javascript
        // Modern JavaScript (ES6+)
        const numbers = [1, 2, 3, 4, 5];
        
        // Arrow functions
        const squares = numbers.map(x => x ** 2);
        
        // Async/await
        async function fetchData(url) {
            const response = await fetch(url);
            const data = await response.json();
            return data;
        }
        
        // Destructuring
        const { name, age } = person;
        const [first, second, ...rest] = array;
        
        // Classes
        class Person {
            constructor(name, age) {
                this.name = name;
                this.age = age;
            }
            
            greet() {
                console.log(`Hello, I'm ${this.name}`);
            }
        }
        ```
        
        Modern JavaScript is powerful and concise!
        """
    }
    
    private func generateExplanation(prompt: String, keywords: [String]) -> String {
        let lower = prompt.lowercased()
        
        if lower.contains("async") || lower.contains("await") {
            return """
            **Understanding Async/Await**
            
            Async/await is a way to write asynchronous code that looks synchronous:
            
            **Why it exists:**
            • Avoids "callback hell"
            • Makes async code easier to read
            • Better error handling
            • Clearer program flow
            
            **How it works:**
            1. `async` marks a function as asynchronous
            2. `await` pauses execution until the promise resolves
            3. Control returns to the event loop during wait
            4. Execution resumes with the result
            
            **Example:**
            ```swift
            // Without async/await (callback pyramid)
            fetchUser { user in
                fetchPosts(for: user) { posts in
                    fetchComments(for: posts) { comments in
                        // Finally do something
                    }
                }
            }
            
            // With async/await (clean and readable)
            let user = try await fetchUser()
            let posts = try await fetchPosts(for: user)
            let comments = try await fetchComments(for: posts)
            ```
            
            The code is more readable and easier to maintain!
            """
        }
        
        if lower.contains("closure") || lower.contains("lambda") {
            return """
            **Understanding Closures**
            
            A closure is a self-contained block of functionality that can be passed around.
            
            **Key concepts:**
            • Closures capture values from their surrounding context
            • They're first-class citizens (can be assigned, passed, returned)
            • Often used for callbacks and functional programming
            
            **Swift syntax:**
            ```swift
            // Full syntax
            let closure = { (param: String) -> String in
                return "Hello, \\(param)"
            }
            
            // Shortened versions
            let short = { param in "Hello, \\(param)" }
            let shorter = { "Hello, \\($0)" }
            
            // Common uses
            [1, 2, 3].map { $0 * 2 }  // [2, 4, 6]
            [1, 2, 3].filter { $0 > 1 }  // [2, 3]
            ```
            
            Think of closures as anonymous functions with superpowers!
            """
        }
        
        return """
        To provide a detailed explanation, I need more context about what you'd like to understand.
        
        Try asking about specific topics like:
        • "Explain async/await"
        • "Explain closures in Swift"
        • "Explain optionals"
        • "Explain protocols"
        • "Explain value vs reference types"
        
        Or describe what you're trying to learn!
        """
    }
    
    private func generateHelpResponse(prompt: String) -> String {
        """
        **Determinal Native AI Help**
        
        I'm a fully offline AI assistant powered by Apple's Natural Language framework.
        
        **What I can help with:**
        
        📝 **Code Generation**
        • Write functions, classes, algorithms
        • Multiple languages (Swift, Python, JavaScript)
        • Examples: "write a function to sort an array"
        
        💡 **Explanations**
        • Concepts and patterns
        • How things work
        • Examples: "explain async/await"
        
        🐛 **Debugging**
        • Problem-solving strategies
        • Common error solutions
        • Examples: "help debug memory leak"
        
        🎯 **Best Practices**
        • Coding standards
        • Design patterns
        • Examples: "best way to handle errors in Swift"
        
        🆚 **Comparisons**
        • Technology choices
        • Approach trade-offs
        • Examples: "struct vs class in Swift"
        
        **Tips for better responses:**
        • Be specific about what you're trying to do
        • Mention the programming language
        • Include context when relevant
        
        Try something like:
        "write a Swift function to parse JSON"
        "explain optionals in Swift"
        "help me fix a retain cycle"
        """
    }
    
    private func generateDebuggingAdvice(prompt: String) -> String {
        """
        **Debugging Advice**
        
        Based on your question, here are some debugging strategies:
        
        **General Debugging Steps:**
        1. Reproduce the issue consistently
        2. Isolate the problem area
        3. Check recent changes
        4. Use print/logging statements
        5. Use the debugger (breakpoints, step through)
        6. Read error messages carefully
        
        **Common Issues & Solutions:**
        
        **Memory Issues:**
        • Check for retain cycles (use weak/unowned)
        • Look for large object accumulation
        • Use Instruments to profile memory
        
        **Crashes:**
        • Check for force unwrapping optionals
        • Verify array bounds
        • Look for threading issues
        
        **Logic Errors:**
        • Add assertions for assumptions
        • Test edge cases
        • Review conditional logic
        
        **Performance:**
        • Profile with Instruments
        • Check for N+1 queries
        • Look for blocking operations on main thread
        
        For specific help, describe:
        • What you expected to happen
        • What actually happened
        • Any error messages
        • Code context
        """
    }
    
    private func generateComparison(prompt: String) -> String {
        let lower = prompt.lowercased()
        
        if lower.contains("struct") && lower.contains("class") {
            return """
            **Struct vs Class in Swift**
            
            **Struct (Value Type):**
            ✓ Copied when assigned/passed
            ✓ Safer in multi-threaded code
            ✓ Automatic memberwise initializer
            ✓ Can't be inherited
            ✓ Stored on stack (faster)
            
            **Class (Reference Type):**
            ✓ Shared when assigned/passed
            ✓ Can be inherited
            ✓ Can have deinitializers
            ✓ Reference counting (ARC)
            ✓ Stored on heap
            
            **When to use each:**
            
            Use **struct** for:
            • Data models
            • Values that don't need identity
            • Simpler types
            • SwiftUI views
            
            Use **class** for:
            • Shared mutable state
            • Inheritance hierarchies
            • Objective-C interop
            • Identity matters
            
            **Example:**
            ```swift
            // Struct - copied
            struct Point {
                var x: Int
                var y: Int
            }
            var p1 = Point(x: 0, y: 0)
            var p2 = p1
            p2.x = 10  // p1.x is still 0
            
            // Class - shared
            class Counter {
                var count = 0
            }
            let c1 = Counter()
            let c2 = c1
            c2.count = 10  // c1.count is also 10!
            ```
            
            Default to struct, use class when you need reference semantics.
            """
        }
        
        return """
        To compare two options, please specify what you'd like to compare.
        
        Popular comparisons:
        • "struct vs class"
        • "async/await vs callbacks"
        • "SwiftUI vs UIKit"
        • "value type vs reference type"
        • "computed property vs method"
        
        Include both options in your question!
        """
    }
    
    private func generateBestPractices(prompt: String) -> String {
        """
        **Swift Best Practices**
        
        **Code Style:**
        • Follow Swift API Design Guidelines
        • Use meaningful names
        • Keep functions focused and small
        • Favor composition over inheritance
        
        **Safety:**
        • Avoid force unwrapping (!)
        • Use guard for early returns
        • Prefer `if let` or optional chaining
        • Handle errors explicitly
        
        **Performance:**
        • Use value types (struct) when possible
        • Avoid unnecessary copying
        • Profile before optimizing
        • Keep main thread free
        
        **SwiftUI:**
        • Use @State for local state
        • Use @Observable for shared state
        • Break views into small components
        • Avoid logic in views
        
        **Concurrency:**
        • Use async/await over callbacks
        • Mark functions async when appropriate
        • Use actors for shared mutable state
        • Avoid blocking the main thread
        
        **Error Handling:**
        • Use Result type for success/failure
        • Throw meaningful errors
        • Document what can fail
        • Provide recovery options
        
        For specific best practices, ask about a particular topic!
        """
    }
    
    private func generateGeneralResponse(prompt: String, keywords: [String]) -> String {
        """
        I understand you're asking about: "\(prompt)"
        
        I'm Determinal's native AI assistant, running completely offline.
        
        To give you the most helpful response, try:
        
        **For code:**
        • "write a [language] function to [task]"
        • "show me how to [action] in [language]"
        
        **For explanations:**
        • "explain [concept]"
        • "what is [term]"
        • "how does [feature] work"
        
        **For help:**
        • "help me [task]"
        • "how do I [goal]"
        • "debug [problem]"
        
        **For comparisons:**
        • "compare [A] and [B]"
        • "difference between [A] and [B]"
        • "[A] vs [B]"
        
        I'm here to help with programming, especially Swift and iOS development!
        """
    }
    
    private func generateDocumentationResponse(prompt: String, keywords: [String]) -> String {
        let lower = prompt.lowercased()
        
        if lower.contains("swift") || lower.contains("ios") || lower.contains("macos") {
            return """
            **Swift & Apple Platform Documentation**
            
            Here are key documentation resources and common topics:
            
            **Core Concepts:**
            • Optionals: Safe handling of nil values
            • Protocols: Define contracts for types
            • Generics: Write flexible, reusable code
            • Error Handling: throw, do-catch, Result
            • Closures: Self-contained blocks of code
            
            **Swift Concurrency:**
            • async/await: Modern asynchronous code
            • Task: Unit of async work
            • Actor: Thread-safe classes
            • AsyncSequence: Async iteration
            
            **SwiftUI:**
            • Views: Building blocks of UI
            • State Management: @State, @Binding, @Observable
            • Layout: VStack, HStack, ZStack
            • Modifiers: Customize appearance
            
            **Foundation:**
            • String, Array, Dictionary
            • Date, Calendar, DateFormatter
            • URL, URLSession
            • FileManager, Bundle
            
            For specific documentation, try:
            • "explain [Swift concept]"
            • "how to use [API]"
            • "show example of [feature]"
            """
        }
        
        return """
        **Programming Documentation Help**
        
        I can provide documentation and guidance on:
        
        **Languages:**
        • Swift (iOS, macOS development)
        • Python
        • JavaScript
        
        **Topics:**
        • Language syntax and features
        • Standard libraries
        • Common patterns
        • API usage
        
        For specific documentation, ask about:
        • A programming language
        • A framework or library
        • A specific concept or feature
        • Example code for a task
        
        Example: "Swift documentation for optionals"
        """
    }
    
    // MARK: - Response Streaming
    
    private func streamResponse(_ response: String, to continuation: AsyncThrowingStream<String, Error>.Continuation) async {
        // Split into words for natural streaming
        let words = response.split(separator: " ")
        
        for (index, word) in words.enumerated() {
            if Task.isCancelled {
                break
            }
            
            // Add space between words (except first word)
            let token = index == 0 ? String(word) : " " + String(word)
            continuation.yield(token)
            
            // Simulate natural typing speed
            try? await Task.sleep(nanoseconds: 30_000_000) // 30ms per word
        }
    }
}
