module Lemma.Soundness where

open import Definition.Untyped
open import Definition.Typed
open import Definition.Typed.Properties
open import Definition.LogicalRelation

open import Data.Product
import Relation.Binary.PropositionalEquality as PE


soundness : ∀ {Γ A} T → ⊢ Γ → Γ ⊩⟨ T ⟩ A → Γ ⊢ A
soundness ⁰ ⊢Γ (ℕ [ Γ⊢A , Γ⊢B , A⇒*B ]) = Γ⊢A
soundness ⁰ ⊢Γ (ne [ Γ⊢A , Γ⊢B , A⇒*B ] neK) = Γ⊢A
soundness ⁰ ⊢Γ (Π [ Γ⊢A , Γ⊢B , A⇒*B ] x₁ x₂ [F] [G] x₃) = Γ⊢A
soundness ¹ ⊢Γ U = U ⊢Γ
soundness ¹ ⊢Γ ℕ = ℕ ⊢Γ
soundness ¹ ⊢Γ (Π x x₁ A [F] [G] x₂) = Π x ▹ x₁
soundness ¹ ⊢Γ (emb x) = soundness ⁰ ⊢Γ x

soundnessEq : ∀ {Γ A B} T → ⊢ Γ → ([A] : Γ ⊩⟨ T ⟩ A) → Γ ⊩⟨ T ⟩ A ≡ B / [A] → Γ ⊢ A ≡ B
soundnessEq ⁰ ⊢Γ (ℕ [ Γ⊢A , Γ⊢B , A⇒*B ]) x₁ = trans (subset* A⇒*B) (sym (subset* x₁))
soundnessEq ⁰ ⊢Γ (ne [ ⊢A , ⊢B , D ] neK) ne[ M , [ ⊢A₁ , ⊢B₁ , D₁ ] , neM , K≡M ] = trans (subset* D) (trans K≡M (sym (subset* D₁)))
soundnessEq ⁰ ⊢Γ (Π x x₁ x₂ [F] [G] x₃) Π⁰[ F' , G' , D' , A≡B , ⊩A , ⊩B , [F≡F'] , [G≡G'] ] = A≡B
soundnessEq ¹ ⊢Γ U x = PE.subst (λ x → _ ⊢ _ ≡ x) (PE.sym x) (refl (U ⊢Γ))
soundnessEq ¹ ⊢Γ ℕ x = PE.subst (λ x → _ ⊢ _ ≡ x) (PE.sym x) (refl (ℕ ⊢Γ))
soundnessEq ¹ ⊢Γ (Π ⊢F ⊢G [A] [F] [G] G-ext) Π¹[ F' , G' , ΠFG≡ΠF'G' , t≡ΠF'G' , [F≡F'] , [G≡G'] ] =
  PE.subst (λ x → _ ⊢ _ ≡ x) (PE.trans ΠFG≡ΠF'G' (PE.sym t≡ΠF'G')) (refl (Π ⊢F ▹ ⊢G))
soundnessEq ¹ ⊢Γ (emb x) x₁ = soundnessEq ⁰ ⊢Γ x x₁

soundnessTerm : ∀ {Γ A t} T → ⊢ Γ → ([A] : Γ ⊩⟨ T ⟩ A) → Γ ⊩⟨ T ⟩ t ∷ A / [A] → Γ ⊢ t ∷ A
soundnessTerm ⁰ ⊢Γ (ℕ [ ⊢A , ⊢B , D ]) ℕ[ n , [ ⊢t , ⊢u , d ] , natN ] = conv ⊢t (sym (subset* D))
soundnessTerm ⁰ ⊢Γ (ne x x₁) t₁ = t₁
soundnessTerm ⁰ ⊢Γ (Π x x₁ x₂ [F] [G] x₃) (proj₁ , proj₂) = proj₁
soundnessTerm ¹ ⊢Γ U (proj₁ , proj₂) = proj₁
soundnessTerm ¹ ⊢Γ ℕ ℕ[ n , [ ⊢t , ⊢u , d ] , natN ] = ⊢t
soundnessTerm ¹ ⊢Γ (Π x x₁ [A] [F] [G] x₂) (proj₁ , proj₂) = proj₁
soundnessTerm ¹ ⊢Γ (emb x) t₁ = soundnessTerm ⁰ ⊢Γ x t₁

soundnessTermEq : ∀ {Γ A t u} T → ⊢ Γ → ([A] : Γ ⊩⟨ T ⟩ A) → Γ ⊩⟨ T ⟩ t ≡ u ∷ A / [A] → Γ ⊢ t ≡ u ∷ A
soundnessTermEq ⁰ ⊢Γ (ℕ [ ⊢A , ⊢B , D ]) ℕ≡[ k , k' , d , d' , t≡u , [k≡k'] ] = conv t≡u (sym (subset* D))
soundnessTermEq ⁰ ⊢Γ (ne x x₁) t≡u = t≡u
soundnessTermEq ⁰ ⊢Γ (Π x x₁ x₂ [F] [G] x₃) (proj₁ , proj₂ , proj₃ , proj₄) = proj₃
soundnessTermEq ¹ ⊢Γ U U[ ⊢t , ⊢u , t≡u , ⊩t , ⊩u , [t≡u] ] = t≡u
soundnessTermEq ¹ ⊢Γ ℕ ℕ≡[ k , k' , d , d' , t≡u , [k≡k'] ] = t≡u
soundnessTermEq ¹ ⊢Γ (Π x x₁ [A] [F] [G] x₂) (proj₁ , proj₂ , proj₃ , proj₄) = proj₃
soundnessTermEq ¹ ⊢Γ (emb x) t≡u = soundnessTermEq ⁰ ⊢Γ x t≡u