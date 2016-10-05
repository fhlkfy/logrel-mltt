module Definition.LogicalRelation.Properties.Reflexivity where

open import Definition.Untyped
open import Definition.Typed
open import Definition.LogicalRelation

open import Data.Product
import Relation.Binary.PropositionalEquality as PE


reflEq : ∀ {l Γ A} ([A] : Γ ⊩⟨ l ⟩ A) → Γ ⊩⟨ l ⟩ A ≡ A / [A]
reflEq (U ⊢Γ) = PE.refl
reflEq (ℕ D) = red D
reflEq (ne [ ⊢A , ⊢B , D ] neK) = ne[ _ , [ ⊢A , ⊢B , D ] , neK , refl ⊢B ]
reflEq (Π [ ⊢A , ⊢B , D ] ⊢F ⊢G [F] [G] G-ext) = Π¹[ _ , _ , D , refl ⊢A , (λ ρ ⊢Δ → reflEq ([F] ρ ⊢Δ)) , (λ ρ ⊢Δ [a] → reflEq ([G] ρ ⊢Δ [a])) ]
reflEq {⁰} (emb {l< = ()} x)
reflEq {¹} (emb {l< = 0<1} x) = reflEq x

reflNatural-prop : ∀ {Γ n} → (natN : Natural n) → natural-prop Γ n natN → [Natural]-prop Γ n n (reflNatural natN)
reflNatural-prop suc ℕ[ n , d , natN , prop ] = ℕ≡[ n , n , d , d , refl (_⊢_:⇒*:_∷_.⊢t d) , reflNatural natN , reflNatural-prop natN prop ]
reflNatural-prop zero t = t
reflNatural-prop (ne x) n = refl n

reflEqTerm : ∀ {l Γ A t} ([A] : Γ ⊩⟨ l ⟩ A) → Γ ⊩⟨ l ⟩ t ∷ A / [A] → Γ ⊩⟨ l ⟩ t ≡ t ∷ A / [A]
reflEqTerm {⁰} (U {l< = ()} ⊢Γ) (⊢t , ⊩t)
reflEqTerm {¹} (U {l< = 0<1} ⊢Γ) (⊢t , ⊩t) = U[ ⊢t , ⊢t , refl ⊢t , ⊩t , ⊩t , reflEq ⊩t ]
reflEqTerm (ℕ D) ℕ[ n , [ ⊢t , ⊢u , d ] , natN , prop ] = ℕ≡[ n , n , [ ⊢t , ⊢u , d ] , [ ⊢t , ⊢u , d ] , refl ⊢t , reflNatural natN , reflNatural-prop natN prop ]
reflEqTerm (ne D neK) t = refl t
reflEqTerm (Π D ⊢F ⊢G [F] [G] G-ext) (⊢t , [t] , [t]₁) = refl ⊢t , (⊢t , [t] , [t]₁) , (⊢t , [t] , [t]₁) , (λ ρ ⊢Δ [a] → [t] ρ ⊢Δ [a] [a] (reflEqTerm ([F] ρ ⊢Δ) [a]))
reflEqTerm {⁰} (emb {l< = ()} x) t
reflEqTerm {¹} (emb {l< = 0<1} x) t = reflEqTerm x t
