module Definition.LogicalRelation.Substitution where

open import Definition.Untyped
open import Definition.LogicalRelation
open import Definition.Typed

open import Tools.Context

open import Data.Nat
open import Data.Product
open import Data.Unit

import Relation.Binary.PropositionalEquality as PE


mutual
  data ⊨⟨_⟩_ (l : TypeLevel) : Con Term → Set where
    ε : ⊨⟨ l ⟩ ε
    _∙_ : ∀ {Γ A} ([Γ] : ⊨⟨ l ⟩ Γ) → Γ ⊨⟨ l ⟩ A / [Γ]
        → ⊨⟨ l ⟩ Γ ∙ A

  _⊨⟨_⟩_/_ : (Γ : Con Term) (l : TypeLevel) (A : Term) → ⊨⟨ l ⟩ Γ -> Set
  Γ ⊨⟨ l ⟩ A / [Γ] = ∀ {Δ σ} {- ⊢ Δ -} → Δ ⊨⟨ l ⟩ σ ∷ Γ / [Γ]
                   → Σ (Δ ⊩⟨ l ⟩ subst σ A)
                       (λ [A] → ∀ {σ'} → Δ ⊨⟨ l ⟩ σ ≡ σ' ∷ Γ / [Γ]
                              → Δ ⊩⟨ l ⟩ subst σ A ≡ subst σ' A / [A])

  _⊨⟨_⟩_∷_/_ : (Δ : Con Term) (l : TypeLevel) (σ : Subst) (Γ : Con Term) ([Γ] : ⊨⟨ l ⟩ Γ) → Set
  Δ ⊨⟨ l ⟩ σ ∷ .ε        / ε                  = ⊤
  Δ ⊨⟨ l ⟩ σ ∷ .(Γ ∙ A) / (_∙_ {Γ} {A} [Γ] [A]) =
    Σ (Δ ⊨⟨ l ⟩ tail σ ∷ Γ / [Γ]) λ [σ] →
    (Δ ⊩⟨ l ⟩ head σ ∷ subst (tail σ) A / proj₁ ([A] [σ]))

  _⊨⟨_⟩_≡_∷_/_ : (Δ : Con Term) (l : TypeLevel) (σ σ' : Subst) (Γ : Con Term) ([Γ] : ⊨⟨ l ⟩ Γ) → Set
  Δ ⊨⟨ l ⟩ σ ≡ σ' ∷ .ε       / ε                   = ⊤
  Δ ⊨⟨ l ⟩ σ ≡ σ' ∷ .(Γ ∙ A) / (_∙_ {Γ} {A} [Γ] [A]) =
    Σ (Δ ⊨⟨ l ⟩ tail σ ∷ Γ / [Γ]) λ [σ] →
    (Δ ⊨⟨ l ⟩ tail σ ≡ tail σ' ∷ Γ / [Γ]) ×
    (Δ ⊩⟨ l ⟩ head σ ≡ head σ' ∷ subst (tail σ) A / proj₁ ([A] [σ]))


_⊨⟨_⟩t_∷_/_/_ : (Γ : Con Term) (l : TypeLevel) (t A : Term) ([Γ] : ⊨⟨ l ⟩ Γ) ([A] : Γ ⊨⟨ l ⟩ A / [Γ]) → Set
Γ ⊨⟨ l ⟩t t ∷ A / [Γ] / [A] =
  ∀ {Δ σ} ([σ] : Δ ⊨⟨ l ⟩ σ ∷ Γ / [Γ]) →
  Σ (Δ ⊩⟨ l ⟩ subst σ t ∷ subst σ A / proj₁ ([A] [σ])) λ [t] →
  ∀ {σ'} → Δ ⊨⟨ l ⟩ σ ≡ σ' ∷ Γ / [Γ]
    → Δ ⊩⟨ l ⟩ subst σ t ≡ subst σ' t ∷ subst σ A / proj₁ ([A] [σ])

_⊨⟨_⟩_≡_/_/_ : (Γ : Con Term) (l : TypeLevel) (A B : Term) ([Γ] : ⊨⟨ l ⟩ Γ) ([A] : Γ ⊨⟨ l ⟩ A / [Γ]) -> Set
Γ ⊨⟨ l ⟩ A ≡ B / [Γ] / [A] =
  ∀ {Δ σ} ([σ] : Δ ⊨⟨ l ⟩ σ ∷ Γ / [Γ])
  → Δ ⊩⟨ l ⟩ subst σ A ≡ subst σ B / proj₁ ([A] [σ])

_⊨⟨_⟩t_≡_∷_/_ : (Γ : Con Term) (l : TypeLevel) (t u A : Term) → ⊨⟨ l ⟩ Γ -> Set
Γ ⊨⟨ l ⟩t t ≡ u ∷ A / [Γ] =
  Σ (Γ ⊨⟨ l ⟩ A / [Γ])            λ [A] →
  Σ (Γ ⊨⟨ l ⟩t t ∷ A / [Γ] / [A]) λ [t] →
  Σ (Γ ⊨⟨ l ⟩t u ∷ A / [Γ] / [A]) λ [u] →
  ∀ {Δ σ} ([σ] : Δ ⊨⟨ l ⟩ σ ∷ Γ / [Γ])
    → Δ ⊩⟨ l ⟩ subst σ t ≡ subst σ u ∷ subst σ A / proj₁ ([A] [σ])
