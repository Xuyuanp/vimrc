scriptencoding utf-8
" copy from https://github.com/enomsg/vim-haskellConcealPlus, removed boring options

syntax match hsNiceOperator "\\\ze[[:alpha:][:space:]_([]" conceal cchar=λ

syntax match hsNiceOperator "\<pi\>" conceal cchar=π

syntax match hsNiceOperator "\<undefined\>" conceal cchar=⊥

syntax match hsNiceOperator "\<forall\>" conceal cchar=∀
syntax match hsNiceOperator "`div`" conceal cchar=÷

" Only replace the dot, avoid taking spaces around.
syntax match hsNiceOperator /\s\.\s/ms=s+1,me=e-1 conceal cchar=∘

syntax match hsQQEnd "|\]" contained conceal cchar=〛
" sy match hsQQEnd "|\]" contained conceal=〚

syntax match hsNiceOperator "`elem`" conceal cchar=∈
syntax match hsNiceOperator "`notElem`" conceal cchar=∉
syntax match hsNiceOperator "`isSubsetOf`" conceal cchar=⊆
syntax match hsNiceOperator "`union`" conceal cchar=∪
syntax match hsNiceOperator "`intersect`" conceal cchar=∩
syntax match hsNiceOperator "\\\\\ze[[:alpha:][:space:]_([]" conceal cchar=∖

" syntax match hsNiceOperator "||\ze[[:alpha:][:space:]_([]" conceal cchar=∨
" syntax match hsNiceOperator "&&\ze[[:alpha:][:space:]_([]" conceal cchar=∧

syntax match hsNiceOperator ">>=" conceal cchar=
syntax match hsNiceOperator "<\*>"      conceal cchar=⊛
" syntax match hsNiceOperator "`mappend`" conceal cchar=⊕
" syntax match hsNiceOperator "\<mappend\>" conceal cchar=⊕
" syntax match hsNiceOperator "<>"        conceal cchar=⊕
syntax match hsNiceOperator "\<empty\>" conceal cchar=∅
syntax match hsNiceOperator "\<mzero\>" conceal cchar=∅
syntax match hsNiceOperator "\<mempty\>" conceal cchar=∅

" syntax match hsNiceOperator "<\*>"      conceal cchar=硫
syntax match hsNiceOperator "`mappend`" conceal cchar=落
syntax match hsNiceOperator "\<mappend\>" conceal cchar=落
syntax match hsNiceOperator "<>"        conceal cchar=落
" syntax match hsNiceOperator "\<empty\>" conceal cchar=
" syntax match hsNiceOperator "\<mzero\>" conceal cchar=
" syntax match hsNiceOperator "\<mempty\>" conceal cchar=

hi link hsNiceOperator Operator
hi! link Conceal Operator
setlocal conceallevel=2

syntax match hsNiceOperator "\<String\>"  conceal cchar=𝐒

syntax match hsNiceOperator "\<Either\>"  conceal cchar=𝐄
syntax match hsNiceOperator "\<Right\>"   conceal cchar=𝑅
syntax match hsNiceOperator "\<Left\>"    conceal cchar=𝐿

syntax match hsNiceOperator "\<Maybe\>"   conceal cchar=𝐌
syntax match hsNiceOperator "\<Just\>"    conceal cchar=𝐽
syntax match hsNiceOperator "\<Nothing\>" conceal cchar=𝑁

" syntax match hsNiceOperator "\<sum\>"                        conceal cchar=∑
" syntax match hsNiceOperator "\<product\>"                    conceal cchar=∏
" syntax match hsNiceOperator "\<sqrt\>"                       conceal cchar=√

syntax match hsNiceOperator "\<sum\>\(\ze\s*[.$]\|\s*\)"     conceal cchar=∑
syntax match hsNiceOperator "\<product\>\(\ze\s*[.$]\|\s*\)" conceal cchar=∏
syntax match hsNiceOperator "\<sqrt\>\(\ze\s*[.$]\|\s*\)"    conceal cchar=√

syntax match hsNiceSpecial "\<True\>"  conceal cchar=𝐓
syntax match hsNiceSpecial "\<False\>" conceal cchar=𝐅

" Not an official notation ttbomk. But at least
" http://www.haskell.org/haskellwiki/Unicode-symbols mentions it.
syntax match hsNiceOperator "\<Bool\>" conceal cchar=𝔹

" Not really Haskell, but quite handy for writing proofs in pseudo-code.
syntax match hsNiceOperator "\<therefore\>" conceal cchar=∴
syntax match hsNiceOperator "\<exists\>" conceal cchar=∃
syntax match hsNiceOperator "\<notExist\>" conceal cchar=∄

" TODO:
" See Basic Syntax Extensions - School of Haskell | FP Complete
" intersection = (∩)
"
" From the Data.IntMap.Strict.Unicode
" notMember = (∉) = flip (∌)
" member = (∈) = flip (∋)
" isProperSubsetOf = (⊂) = flip (⊃)
"
" From Data.Sequence.Unicode
" (<|) = (⊲ )
" (|>) = (⊳ )
" (><) = (⋈ )
