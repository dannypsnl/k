#lang k/base
(provide (data-out Σ)
         (rename-out [Σ Sigma]))

(data (Σ [A : Type]
         [B : (-> A Type)])
      : Type
      [fst : A]
      [snd : (B fst)])
