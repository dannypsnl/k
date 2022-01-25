# Termination check

## sized type

- [paper](https://arxiv.org/pdf/1012.4896.pdf)

> Sized types are a modular and theoretically well-understood tool for checking termination of recursive and productivity of corecursive definitions. The essential idea is to track structural descent and guardedness in the type system to make termination checking robust and suitable for strong abstractions like higher-order functions and polymorphism. To study the application of sized types to proof assistants and programming languages based on dependent type theory, we have implemented a core language, MiniAgda, with explicit handling of sizes. New considerations were necessary to soundly integrate sized types with dependencies and pattern matching, which was made possible by concepts such as inaccessible patterns and parametric function spaces. This paper provides an introduction to MiniAgda by example and informal explanations of the underlying principles

- [video Towards a Syntactic Model of Sized Dependent Types](https://www.youtube.com/watch?v=OKgVF2IS_dU)
