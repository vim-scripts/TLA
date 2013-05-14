" tla.vim
" @Author:      xingchao <xingchao19811209@gmail.com>
" @Website:     
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     Sun Apr 22 03:03:58 CST 2012.
" @Last Change:   
" @Revision:    0.1

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let g:TLA_PATH = ''
let g:TLA_PdfLatex = ''
let s:tla_template             = { 'default' : {} }
let s:TLA_ActualStyle					= 'default'
let s:TLA_GlobalTemplateDir	= ''

let s:Attribute                = { 'below':'', 'above':'', 'start':'', 'append':'', 'insert':'' }
let s:TLA_Attribute           = {}
let s:TLA_Macro                = {'|AUTHOR|'         : 'first name surname',
      \						 '|AUTHORREF|'      : '',
      \						 '|EMAIL|'          : '',
      \						 '|COMPANY|'        : '',
      \						 '|PROJECT|'        : '',
      \						 '|COPYRIGHTHOLDER|': '',
      \		 				 '|STYLE|'          : ''
      \						}

let s:installation						= 'local'
let s:vimfiles								= $VIM
let s:TLA_MacroNameRegex        = '\([a-zA-Z][a-zA-Z0-9_]*\)'
let s:TLA_MacroCommentRegex		 = '^§'
let s:TLA_MacroLineRegex				 = '^\s*|'.s:TLA_MacroNameRegex.'|\s*=\s*\(.*\)'

let s:TLA_ExpansionRegex				 = '|?'.s:TLA_MacroNameRegex.'\(:\a\)\?|'
let s:TLA_NonExpansionRegex		 = '|'.s:TLA_MacroNameRegex.'\(:\a\)\?|'
let s:TLA_TemplateNameDelimiter = '-+_,\. '
let s:TLA_TemplateLineRegex		 = '^==\s*\([a-zA-Z][0-9a-zA-Z'.s:TLA_TemplateNameDelimiter
let s:TLA_TemplateLineRegex		.= ']\+\)\s*==\s*\([a-z]\+\s*==\)\?'
let s:TLA_TemplateIf						 = '^==\s*IF\s\+|STYLE|\s\+IS\s\+'.s:TLA_MacroNameRegex.'\s*=='
let s:TLA_TemplateEndif				 = '^==\s*ENDIF\s*=='


let s:TLA_Ctrl_j								= 'on'
let s:TLA_TJT									= '[ 0-9a-zA-Z_]*'
let s:TLA_TemplateJumpTarget1  = '<+'.s:TLA_TJT.'+>\|{+'.s:TLA_TJT.'+}'
let s:TLA_TemplateJumpTarget2  = '<-'.s:TLA_TJT.'->\|{-'.s:TLA_TJT.'-}'
let s:TLA_TemplateOverwrittenMsg = 'yes' 


let s:TLA_LineEndCommColDefault = 149
let s:TLA_LoadMenus      				= 'yes'
" let s:TLA_OutputGvim            = 'vim'
let s:TLA_Printheader           = "%<%f%h%m%<  %=%{strftime('%x %X')}     Page %N"
let s:TLA_Root  	       				= '&TLA+.'           " the name of the root menu of this plugin
let s:TLA_TypeOfH               = 'tla'
let s:TLA_FormatDate						= '%x'
let s:TLA_FormatTime						= '%X'
let s:TLA_FormatYear						= '%Y'
let s:TLA_SourceCodeExtensions  = 'tla'



let	s:MSWIN =		has("win16") || has("win32") || has("win64") || has("win95")
"
if	s:MSWIN
  if match(resolve( expand("<sfile>")), $VIM ) >= 0
    " if match( s:sourced_script_file, escape( s:vimfiles, ' \' ) ) == 0
    " system wide installation
    let s:installation						= 'system'
    let s:plugin_dir							= $VIM.'\vimfiles\'
  else
    " user installation assumed
    let s:plugin_dir  						= $VIM.'\vimfiles\'
  endif
  "
  "------------------------------------------------------------------------------
  "
  "  g:TLA_Dictionary_File  must be global
  "
  if !exists("g:TLA_Dictionary_File")
    let g:TLA_Dictionary_File     = s:plugin_dir.'tla-support\wordlists\tla.list'
  endif
  "

  let g:TLA_PATH = 'c:\tla'
  "pdflatex is already in PATH
  " let g:TLA_PdfLatexDir = 'C:\Program Files (x86)\ProTeXt\MiKTex\miktex\bin\x64\'
  let s:TLA_GlobalTemplateDir	= s:plugin_dir.'tla-support\templates'
  let s:TLA_GlobalTemplateFile = s:TLA_GlobalTemplateDir.'\Templates'
  let s:TLA_LocalTemplateFile    = s:plugin_dir.'\tla-support\templates\Templates'
  let s:TLA_LocalTemplateDir     = fnamemodify( s:TLA_LocalTemplateFile, ":p:h" ).'\'
  let s:TLA_CodeSnippets 				= s:plugin_dir.'\tla-support\codesnippets\'
  let s:TLA_tla2sany							= 'java -cp '.g:TLA_PATH.'  tla2sany.SANY'
  let s:TLA_tlc									= 'java -cp '.g:TLA_PATH.'  tlc2.TLC'
  let s:TLA_OutputGvim						= 'xterm'

else "linux
  if match( expand("<sfile>"), $VIM ) >= 0
    " if match( s:sourced_script_file, escape( s:vimfiles, ' \' ) ) == 0
    " system wide installation
    let s:installation						= 'system'
    let s:plugin_dir							= $VIM.'/.vim/'
  else
    " user installation assumed
    let s:plugin_dir  						= $HOME.'/.vim/'
  endif
  "
  "------------------------------------------------------------------------------
  "
  "  g:TLA_Dictionary_File  must be global
  "
  if !exists("g:TLA_Dictionary_File")
    let g:TLA_Dictionary_File     = s:plugin_dir.'tla-support/wordlists/tla.list'
  endif
  "

  let g:TLA_PATH = '/opt/tla'
  let s:TLA_GlobalTemplateDir	= s:plugin_dir.'tla-support/templates'
  let s:TLA_GlobalTemplateFile = s:TLA_GlobalTemplateDir.'/Templates'
  let s:TLA_LocalTemplateFile    = s:plugin_dir.'/tla-support/templates/Templates'
  let s:TLA_LocalTemplateDir     = fnamemodify( s:TLA_LocalTemplateFile, ":p:h" ).'/'
  let s:TLA_CodeSnippets 				= s:plugin_dir.'/tla-support/codesnippets/'
  let s:TLA_tla2sany							= 'java tla2sany.SANY'
  let s:TLA_tlc									= 'java tlc2.TLC'
  let s:TLA_OutputGvim						= 'xterm'
endif

"
" ---------- TLA dictionary -----------------------------------
"
" This will enable keyword completion for tla
if exists("g:TLA_Dictionary_File")
  let save=&dictionary
  silent! exe 'setlocal dictionary='.g:TLA_Dictionary_File
  silent! exe 'setlocal dictionary+='.save
endif    


"
"  Look for global variables (if any), to override the defaults.
"
function! TLA_CheckGlobal ( name )
  if exists('g:'.a:name)
    exe 'let s:'.a:name.'  = g:'.a:name
  endif
endfunction    " ----------  end of function TLA_CheckGlobal ----------

call TLA_CheckGlobal('TLA_LineEndCommColDefault')
call TLA_CheckGlobal('TLA_LoadMenus')
call TLA_CheckGlobal('TLA_OutputGvim')
call TLA_CheckGlobal('TLA_Printheader')
call TLA_CheckGlobal('TLA_Root')
call TLA_CheckGlobal('TLA_TypeOfH')
call TLA_CheckGlobal('TLA_FormatDate')
call TLA_CheckGlobal('TLA_FormatTime')
call TLA_CheckGlobal('TLA_FormatYear')
call TLA_CheckGlobal('TLA_SourceCodeExtensions')
call TLA_CheckGlobal('installation')
call TLA_CheckGlobal('plugin_dir')
call TLA_CheckGlobal('TLA_GlobalTemplateDir')
call TLA_CheckGlobal('TLA_GlobalTemplateFile')
call TLA_CheckGlobal('TLA_CodeSnippets')
call TLA_CheckGlobal('TLA_tla2sany')
call TLA_CheckGlobal('TLA_tlc')
call TLA_CheckGlobal('TLA_PATH')
call TLA_CheckGlobal('tla_template             ')
call TLA_CheckGlobal('TLA_ActualStyle					')
call TLA_CheckGlobal('TLA_GlobalTemplateDir	')
call TLA_CheckGlobal('TLA_Attribute           ')
call TLA_CheckGlobal('TLA_Macro                ')
call TLA_CheckGlobal('installation						')
call TLA_CheckGlobal('vimfiles')
call TLA_CheckGlobal('TLA_MacroCommentRegex		 ')
call TLA_CheckGlobal('TLA_MacroLineRegex				 ')
call TLA_CheckGlobal('TLA_TemplateLineRegex		 ')
call TLA_CheckGlobal('TLA_TemplateIf						 ')
call TLA_CheckGlobal('TLA_TemplateEndif				 ')
call TLA_CheckGlobal('TLA_MacroNameRegex        ')
call TLA_CheckGlobal('TLA_TemplateNameDelimiter ')
call TLA_CheckGlobal('TLA_ExpansionRegex ')
call TLA_CheckGlobal('TLA_NonExpansionRegex ')
call TLA_CheckGlobal('TLA_Ctrl_j								')
call TLA_CheckGlobal('TLA_TJT')
call TLA_CheckGlobal('TLA_TemplateJumpTarget1')
call TLA_CheckGlobal('TLA_TemplateJumpTarget2')
call TLA_CheckGlobal('TLA_TemplateOverwrittenMsg')


let s:TLA_tla2sanyExist = 1
" if executable(s:TLA_tla2sany)
" let s:TLA_tla2sanyExist = 1
" endif

let s:TLA_tlc2exist = 1
" if executable(s:TLA_tlc)
" let s:TLA_tlc2exist = 1
" endif

"------------------------------------------------------------------------------
"  TLA+ : TLA_InitMenus                              {{{1
"  Initialization of TLA+ support menus
"------------------------------------------------------------------------------
"
" the menu names
"
let s:Operator     = s:TLA_Root.'&Operator'
let s:Constructs   = s:TLA_Root.'&Constructs'
let s:snippets          = s:TLA_Root.'&snippets'
let s:Comments          = s:TLA_Root.'&Comments'
let s:Run          = s:TLA_Root.'&Run'
"
function! TLA_InitMenus ()
  "
  "===============================================================================================
  "----- Menu : TLA+-Operator --------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  "----- Submenu : TLA+-Operator : Operator defined in the standard modules  ---------------------
  "
  "
  "----- SubSubmenu : TLA+-Operator : Operator defined in the standard modules Naturals Integers Reals ---------------------
  "
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.+        :call TLA_InsertTemplate("operator.plus")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.\ -        :call TLA_InsertTemplate("operator.minus")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.*        :call TLA_InsertTemplate("operator.multiply")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>./        :call TLA_InsertTemplate("operator.divide")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.^\ (exponentiation)        :call TLA_InsertTemplate("operator.exponentiation")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.\.\.        :call TLA_InsertTemplate("operator.twodot")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.Nat        :call TLA_InsertTemplate("operator.Nat")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.Real        :call TLA_InsertTemplate("operator.Real")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.\\div        :call TLA_InsertTemplate("operator.slash-div")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.%        :call TLA_InsertTemplate("operator.mod")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.\\leq(=<\ or\ <=)        :call TLA_InsertTemplate("operator.slash-leq")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.\\geq(>=)        :call TLA_InsertTemplate("operator.slash-geq")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.<        :call TLA_InsertTemplate("operator.less")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.>        :call TLA_InsertTemplate("operator.greater")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.Int        :call TLA_InsertTemplate("operator.Int")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.NaturalsIntegersReals<Tab>.Infinity        :call TLA_InsertTemplate("operator.Infinity")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator : Operator defined in the standard module Sequences  ---------------------
  "
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.\\circ(\\o)        :call TLA_InsertTemplate("operator.slash-circ")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.Head        :call TLA_InsertTemplate("operator.Head")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.SelectSeq        :call TLA_InsertTemplate("operator.SelectSeq")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.SubSeq        :call TLA_InsertTemplate("operator.SubSeq")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.Append        :call TLA_InsertTemplate("operator.Append")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.Len        :call TLA_InsertTemplate("operator.Len")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.Seq        :call TLA_InsertTemplate("operator.Seq")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Sequences<Tab>.Tail        :call TLA_InsertTemplate("operator.Tail")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator : Operator defined in the standard module FiniteSets  ---------------------
  "
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.FiniteSets<Tab>.IsFiniteSet        :call TLA_InsertTemplate("operator.IsFiniteSet")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.FiniteSets<Tab>.Cardinality        :call TLA_InsertTemplate("operator.Cardinality")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator : Operator defined in the standard module Bags  ---------------------
  "
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.\\oplus((+))        :call TLA_InsertTemplate("operator.slash-oplus")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.BagIn        :call TLA_InsertTemplate("operator.BagIn")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.CopiesIn        :call TLA_InsertTemplate("operator.CopiesIn")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.SubBag        :call TLA_InsertTemplate("operator.SubBag")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.\\ominus((-))        :call TLA_InsertTemplate("operator.slash-ominus")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.BagOfAll        :call TLA_InsertTemplate("operator.BagOfAll")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.EmptyBag        :call TLA_InsertTemplate("operator.EmptyBag")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.\\sqsubseteq        :call TLA_InsertTemplate("operator.slash-sqsubseteq")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.BagToSet        :call TLA_InsertTemplate("operator.BagToSet")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.IsABag        :call TLA_InsertTemplate("operator.IsABag")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.BagCardinality        :call TLA_InsertTemplate("operator.BagCardinality")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.BagUnion        :call TLA_InsertTemplate("operator.BagUnion")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.Bags<Tab>.SetToBag        :call TLA_InsertTemplate("operator.SetToBag")<CR>'


  "
  "----- SubSubmenu : TLA+-Operator : Operator defined in the standard module RealTime  ---------------------
  "
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.RealTime<Tab>.RTBound        :call TLA_InsertTemplate("operator.RTBound")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.RealTime<Tab>.RTnow        :call TLA_InsertTemplate("operator.RTnow")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.RealTime<Tab>.now        :call TLA_InsertTemplate("operator.now")<CR>'


  "
  "----- SubSubmenu : TLA+-Operator : Operator defined in the standard module TLC  ---------------------
  "
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.TLC<Tab>.:>        :call TLA_InsertTemplate("operator.colon-greater")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.TLC<Tab>.@@        :call TLA_InsertTemplate("operator.atat")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.TLC<Tab>.Print        :call TLA_InsertTemplate("operator.Print")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.TLC<Tab>.Assert        :call TLA_InsertTemplate("operator.Assert")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.TLC<Tab>.JavaTime        :call TLA_InsertTemplate("operator.JavaTime")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.TLC<Tab>.Permutations        :call TLA_InsertTemplate("operator.Permutations")<CR>'
  exe "amenu  ".s:Operator.'.&DefinedInTheStandardModules<Tab>.TLC<Tab>.SortSeq        :call TLA_InsertTemplate("operator.SortSeq")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator :Action Operators ---------------------
  "
  exe "amenu  ".s:Operator.'.&Action\ operators<Tab>.prime      :call TLA_InsertTemplate("operator.prime")<CR>'
  exe "amenu  ".s:Operator.'.&Action\ operators<Tab>.[A]_e       :call TLA_InsertTemplate("operator.square-action-parameter")<CR>'
  exe "amenu  ".s:Operator.'.&Action\ operators<Tab>.<A>_e       :call TLA_InsertTemplate("operator.angle-action-parameter")<CR>'
  exe "amenu  ".s:Operator.'.&Action\ operators<Tab>.ENABLED\ A       :call TLA_InsertTemplate("operator.ENABLED")<CR>'
  exe "amenu  ".s:Operator.'.&Action\ operators<Tab>.UNCHANGED\ e       :call TLA_InsertTemplate("operator.UNCHANGED")<CR>'
  exe "amenu  ".s:Operator.'.&Action\ operators<Tab>.A\ \\cdot\ B\ (composition)       :call TLA_InsertTemplate("operator.slash-cdot")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator :Temporal Operators ---------------------
  "
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.[]F       :call TLA_InsertTemplate("operator.always")<CR>'
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.<>F       :call TLA_InsertTemplate("operator.eventually")<CR>'
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.WF_e(A)       :call TLA_InsertTemplate("operator.weak-fairness")<CR>'
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.SF_e(A)       :call TLA_InsertTemplate("operator.strong-fairness")<CR>'
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.F\ ~>\ G       :call TLA_InsertTemplate("operator.lead")<CR>'
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.F\ -+->\ G       :call TLA_InsertTemplate("operator.guarantee")<CR>'
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.\\EE\ x\ :\ F       :call TLA_InsertTemplate("operator.temporal-existential-quantification")<CR>'
  exe "amenu  ".s:Operator.'.&Temporal\ operators<Tab>.\\AA\ x\ :\ F             :call TLA_InsertTemplate("operator.temporal-universal-quantification")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator :Infix Operators ---------------------
  "
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.+       :call TLA_InsertTemplate("operator.plus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\ -       :call TLA_InsertTemplate("operator.minus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.*       :call TLA_InsertTemplate("operator.multiply")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>./       :call TLA_InsertTemplate("operator.divide")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\o(\\circ)       :call TLA_InsertTemplate("operator.slash-circ")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.++       :call TLA_InsertTemplate("operator.plus-plus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\div       :call TLA_InsertTemplate("operator.slash-div")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.%       :call TLA_InsertTemplate("operator.mod")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.^       :call TLA_InsertTemplate("operator.exponentiation")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\.\.       :call TLA_InsertTemplate("operator.twodot")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\.\.\.       :call TLA_InsertTemplate("operator.dot-dot-dot")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\ --       :call TLA_InsertTemplate("operator.minus-minus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\oplus((+))       :call TLA_InsertTemplate("operator.slash-oplus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\ominus((-))       :call TLA_InsertTemplate("operator.slash-ominus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\otimes(\\X)       :call TLA_InsertTemplate("operator.slash-otimes")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\oslash(/)       :call TLA_InsertTemplate("operator.slash-oslash")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\odot(\.)       :call TLA_InsertTemplate("operator.slash-odot")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.**       :call TLA_InsertTemplate("operator.star-star")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.<       :call TLA_InsertTemplate("operator.less")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.>       :call TLA_InsertTemplate("operator.greater")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\leq(=<\ or\ <=)       :call TLA_InsertTemplate("operator.slash-leq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\geq(>=)       :call TLA_InsertTemplate("operator.slash-geq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\sqcap       :call TLA_InsertTemplate("operator.slash-sqcap")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.//       :call TLA_InsertTemplate("operator.the-slash")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\prec       :call TLA_InsertTemplate("operator.slash-prec")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\succ       :call TLA_InsertTemplate("operator.slash-succ")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\preceq       :call TLA_InsertTemplate("operator.slash-preceq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\succeq       :call TLA_InsertTemplate("operator.slash-succeq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\sqcup       :call TLA_InsertTemplate("operator.slash-sqcup")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.^^       :call TLA_InsertTemplate("operator.exp-exp")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.ll       :call TLA_InsertTemplate("operator.slash-ll")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\gg       :call TLA_InsertTemplate("operator.slash-gg")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.<:       :call TLA_InsertTemplate("operator.less-colon")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.>:       :call TLA_InsertTemplate("operator.greater-colon")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\ &       :call TLA_InsertTemplate("operator.and")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\ &&       :call TLA_InsertTemplate("operator.and-and")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\sqsubset       :call TLA_InsertTemplate("operator.slash-sqsubset")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\sqsupset       :call TLA_InsertTemplate("operator.slash-sqsupset")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\sqsubseteq       :call TLA_InsertTemplate("operator.slash-sqsubseteq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\sqsupseteq       :call TLA_InsertTemplate("operator.slash-sqsupseteq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\|       :call TLA_InsertTemplate("operator.or")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\|\|       :call TLA_InsertTemplate("operator.or-or")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\subset       :call TLA_InsertTemplate("operator.slash-subset")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\supset       :call TLA_InsertTemplate("operator.slash-supset")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\subseteq       :call TLA_InsertTemplate("operator.slash-subseteq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\supseteq       :call TLA_InsertTemplate("operator.slash-supseteq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\star       :call TLA_InsertTemplate("operator.slash-star")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.%%       :call TLA_InsertTemplate("operator.mod-mod")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\|-       :call TLA_InsertTemplate("operator.or-minus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.-\|       :call TLA_InsertTemplate("operator.minus-or")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\|=       :call TLA_InsertTemplate("operator.or-equiv")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.=\|       :call TLA_InsertTemplate("operator.equiv-or")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\bullet       :call TLA_InsertTemplate("operator.slash-bullet")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.##       :call TLA_InsertTemplate("operator.sharp-sharp")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\sim       :call TLA_InsertTemplate("operator.slash-sim")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\simeq       :call TLA_InsertTemplate("operator.slash-simeq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\approx       :call TLA_InsertTemplate("operator.slash-approx")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\cong       :call TLA_InsertTemplate("operator.slash-cong")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.$       :call TLA_InsertTemplate("operator.dollar")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.$$       :call TLA_InsertTemplate("operator.dollar-dollar")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.:=       :call TLA_InsertTemplate("operator.colon-equiv")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.::=       :call TLA_InsertTemplate("operator.colon-colon-equiv")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\asymp       :call TLA_InsertTemplate("operator.slash-asymp")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\doteq       :call TLA_InsertTemplate("operator.slash-doteq")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.??       :call TLA_InsertTemplate("operator.question-question")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.!!       :call TLA_InsertTemplate("operator.exclamation-exclamation")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\propto       :call TLA_InsertTemplate("operator.slash-propto")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\wr       :call TLA_InsertTemplate("operator.slash-wr")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\uplus       :call TLA_InsertTemplate("operator.slash-uplus")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.\\bigcirc       :call TLA_InsertTemplate("operator.slash-bigcirc")<CR>'
  exe "amenu  ".s:Operator.'.&Infix\ operators<Tab>.@@       :call TLA_InsertTemplate("operator.atat")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator :Postfix Operators ---------------------
  "
  exe "amenu  ".s:Operator.'.&Postfix\ operators<Tab>.^+       :call TLA_InsertTemplate("operator.exp-plus")<CR>'
  exe "amenu  ".s:Operator.'.&Postfix\ operators<Tab>.^*       :call TLA_InsertTemplate("operator.exp-multiply")<CR>'
  exe "amenu  ".s:Operator.'.&Postfix\ operators<Tab>.^#       :call TLA_InsertTemplate("operator.exp-sharp")<CR>'


  "
  "----- SubSubmenu : TLA+-Operator :Prefix Operators ---------------------
  "
  exe "amenu  ".s:Operator.'.&Prefix\ operators<Tab>.\ -       :call TLA_InsertTemplate("operator.minus")<CR>'


  "
  "----- SubSubmenu : TLA+-Operator :  Constant Operators : Logic -------------------------
  "
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>./\\       :call TLA_InsertTemplate("operator.conjunction")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.\\/       :call TLA_InsertTemplate("operator.disjunction")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.\\neg(\\lnot\ or\ ~)       :call TLA_InsertTemplate("operator.slash-neg")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.=>       :call TLA_InsertTemplate("operator.imply")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.\\equiv(<=>)       :call TLA_InsertTemplate("operator.slash-equiv")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.TRUE       :call TLA_InsertTemplate("operator.true")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.FALSE       :call TLA_InsertTemplate("operator.false")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.BOOLEAN       :call TLA_InsertTemplate("operator.boolean")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.\\Ax\ :\ p       :call TLA_InsertTemplate("operator.all-x-p")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.\\Ex\ :\ p       :call TLA_InsertTemplate("operator.exist-x-p")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.\\Ax\ \in\ S\ :\ p        :call TLA_InsertTemplate("operator.all-x-in-S-p")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.\\Ex\ \in\ S\ :\ p        :call TLA_InsertTemplate("operator.exist-x-in-S-p")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.CHOOSE\ x\ :\ p               :call TLA_InsertTemplate("operator.choose-x-p")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Logic<Tab>.CHOOSE\ x\ \in\ S\ :\ p               :call TLA_InsertTemplate("operator.choose-x-in-S-p")<CR>'



  "
  "----- SubSubmenu : TLA+-Operator :  Constant Operators : Sets -------------------------
  "
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.=               :call TLA_InsertTemplate("operator.set-equiv")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.#(/=)               :call TLA_InsertTemplate("operator.set-not-equiv")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.\\in               :call TLA_InsertTemplate("operator.slash-in")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.\\notin               :call TLA_InsertTemplate("operator.slash-notin")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.\\cup(\\union)               :call TLA_InsertTemplate("operator.slash-cup")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.\\cap(\\intersect)               :call TLA_InsertTemplate("operator.slash-cap")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.\\subseteq               :call TLA_InsertTemplate("operator.slash-subseteq")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.\\\ (set\ difference)               :call TLA_InsertTemplate("operator.set-difference")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.{e1,\.\.\.,en}               :call TLA_InsertTemplate("operator.set-consist-e1-en")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.{x\ \in\ S\ :\ p}               :call TLA_InsertTemplate("operator.set-in-S-p")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.{e\ :\ x\ \in\ S}               :call TLA_InsertTemplate("operator.set-of-e-x-in-S")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.SUBSET\ \S              :call TLA_InsertTemplate("operator.subset")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Sets<Tab>.UNION\ \S              :call TLA_InsertTemplate("operator.union")<CR>'



  "
  "----- SubSubmenu : TLA+-Operator :  Constant Operators : Functions -------------------------
  "
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Functions<Tab>.f[e]              :call TLA_InsertTemplate("operator.function")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Functions<Tab>.DOMAIN\ f              :call TLA_InsertTemplate("operator.domain-of-function")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Functions<Tab>.[x\ \in\ S\ \|->\ e]              :call TLA_InsertTemplate("operator.x-in-S-e")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Functions<Tab>.[S\ \|->\ T]              :call TLA_InsertTemplate("operator.set-of-functions")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Functions<Tab>.[f\ EXCEPT\ ![e1]\ =\ e2]              :call TLA_InsertTemplate("operator.function-except")<CR>'



  "
  "----- SubSubmenu : TLA+-Operator :  Constant Operators : Records -------------------------
  "
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Records<Tab>.e\.h              :call TLA_InsertTemplate("operator.h-field-of-e")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Records<Tab>.[h1\ \|->\ e1,\.\.\.,hn\ \|->\ en]              :call TLA_InsertTemplate("operator.hi-is-ei")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Records<Tab>.[h1\ :\ S1,\.\.\.,hn\ :\ Sn]              :call TLA_InsertTemplate("operator.set-of-records-hi-in-Si")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Records<Tab>.[r\ EXCEPT\ !\.h\ =\ e]              :call TLA_InsertTemplate("operator.record-except")<CR>'

  "
  "----- SubSubmenu : TLA+-Operator :  Constant Operators : Tuples -------------------------
  "
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Tuples<Tab>.e[i]              :call TLA_InsertTemplate("operator.ith-of-e")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Tuples<Tab>.<<e1,\.\.\.,en>>              :call TLA_InsertTemplate("operator.n-tuple")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Tuples<Tab>.S1X,\.\.\.,XSn              :call TLA_InsertTemplate("operator.set-of-n-tuples")<CR>'

  "
  "
  "----- SubSubmenu : TLA+-Operator :  Constant Operators : Strings Numbers -------------------------
  "
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Strings\ Numbers<Tab>."c1\ \.\.\.\ cn"              :call TLA_InsertTemplate("operator.string-of-n-characters")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Strings\ Numbers<Tab>.STRING              :call TLA_InsertTemplate("operator.set-of-strings")<CR>'
  exe "amenu  ".s:Operator.'.&Constant\ operators<Tab>.Strings\ Numbers<Tab>.d1\.\.\.dn\ \ d1\.\.\.dn\.d(n+1)\.\.\.dm              :call TLA_InsertTemplate("operator.numbers")<CR>'




  "
  exe "amenu  ".s:Operator.'.-SEP8-                        :'
  "







  "===============================================================================================
  "----- Menu : TLA+-Constructs-------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  exe "amenu <silent>".s:Constructs.'.IF\ \THEN\ E&LSE\ <Tab>\\gi      :call TLA_InsertTemplate("statements.IF-THEN-ELSE")<CR>'
  exe "vmenu <silent>".s:Constructs.'.IF\ \THEN\ E&LSE\ <Tab>\\gi <Esc>:call TLA_InsertTemplate("statements.IF-THEN-ELSE", "v")<CR>'
  exe "imenu <silent>".s:Constructs.'.IF\ \THEN\ E&LSE\ <Tab>\\gi <Esc>:call TLA_InsertTemplate("statements.IF-THEN-ELSE")<CR>'
  "
  exe "amenu <silent>".s:Constructs.'.&CASE\ []\ \.\.\.[]\ <Tab>\\ga                    :call TLA_InsertTemplate("statements.CASE")<CR>'
  exe "vmenu <silent>".s:Constructs.'.&CASE\ []\ \.\.\.[]\ <Tab>\\ga               <Esc>:call TLA_InsertTemplate("statements.CASE", "v")<CR>'
  exe "imenu <silent>".s:Constructs.'.&CASE\ []\ \.\.\.[]\ <Tab>\\ga               <Esc>:call TLA_InsertTemplate("statements.CASE")<CR>'
  "
  exe "amenu <silent>".s:Constructs.'.&CASE\ []\ \.\.\.[]\ []OTHER<Tab>\\go                    :call TLA_InsertTemplate("statements.CASE-OTHER")<CR>'
  exe "vmenu <silent>".s:Constructs.'.&CASE\ []\ \.\.\.[]\ []OTHER<Tab>\\go               <Esc>:call TLA_InsertTemplate("statements.CASE-OTHER", "v")<CR>'
  exe "imenu <silent>".s:Constructs.'.&CASE\ []\ \.\.\.[]\ []OTHER<Tab>\\go               <Esc>:call TLA_InsertTemplate("statements.CASE-OTHER")<CR>'
  "
  exe "amenu <silent>".s:Constructs.'.LET\ IN\ /\\\.\.\./\\<Tab>\\glc                    :call TLA_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>'
  exe "vmenu <silent>".s:Constructs.'.LET\ IN\ /\\\.\.\./\\<Tab>\\glc                    <Esc>:call TLA_InsertTemplate("statements.LET-IN-CONJUNCTION", "v")<CR>'
  exe "imenu <silent>".s:Constructs.'.LET\ IN\ /\\\.\.\./\\<Tab>\\glc                    <Esc>:call TLA_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>'
  "
  exe "amenu <silent>".s:Constructs.'.LET\ IN\ \\/\.\.\.\\/<Tab>\\gld                    :call TLA_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>'
  exe "vmenu <silent>".s:Constructs.'.LET\ IN\ \\/\.\.\.\\/<Tab>\\gld                    <Esc>:call TLA_InsertTemplate("statements.LET-IN-DISJUNCTION", "v")<CR>'
  exe "imenu <silent>".s:Constructs.'.LET\ IN\ \\/\.\.\.\\/<Tab>\\gld                    <Esc>:call TLA_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>'






  "
  "===============================================================================================
  "----- Menu : snippets  ----- --------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  "
  exe "amenu  <silent>  ".s:snippets.'.Frame<Tab>\\sf                               :call TLA_InsertTemplate("tla.frame")<CR>'
  exe "imenu  <silent>  ".s:snippets.'.Frame<Tab>\\sf                          <C-C>:call TLA_InsertTemplate("tla.frame")<CR>'
  exe "amenu  <silent>  ".s:snippets.'.-SEP1-                          :'
  "
  " exe "amenu  <silent>  ".s:Run.'.&tlc2<Tab>\\tlc                                    :call TLA_Tlc2()<CR>'
  " exe "imenu  <silent>  ".s:Run.'.&tlc2<Tab>\\tlc                               <C-C>:call TLA_Tlc2()<CR>'
  " exe "amenu  <silent>  ".s:Run.'.-SEP2-                          :'
  "


  "
  "===============================================================================================
  "----- Menu : run  ----- --------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  "
  if s:TLA_tla2sanyExist ==1
    exe "amenu  <silent>  ".s:Run.'.tla2sany<Tab>\F9                               :call TLA_Tla2sany()<CR>'
    exe "imenu  <silent>  ".s:Run.'.tla2sany<Tab>\F9                          <C-C>:call TLA_Tla2sany()<CR>'
    exe "amenu  <silent>  ".s:Run.'.cmd\.\ line\ arg\.\ for\ tla2sany<Tab>\F10      :call TLA_Tla2sanyArguments()<CR>'
    exe "imenu  <silent>  ".s:Run.'.cmd\.\ line\ arg\.\ for\ tla2sany<Tab>\F10 <C-C>:call TLA_Tla2sanyArguments()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP1-                          :'
  endif
  "
  if s:TLA_tlc2exist ==1
    exe "amenu  <silent>  ".s:Run.'.&tlc2<Tab>\F11                                    :call TLA_Tlc2()<CR>'
    exe "imenu  <silent>  ".s:Run.'.&tlc2<Tab>\F11                               <C-C>:call TLA_Tlc2()<CR>'
    exe "amenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ tlc2<Tab>\F12           :call TLA_Tlc2Arguments()<CR>'
    exe "imenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ tlc2<Tab>\F12      <C-C>:call TLA_Tlc2Arguments()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP2-                          :'
  endif

    exe "amenu  <silent>  ".s:Run.'.&pcal<Tab>\F7                                    :call TLA_PcalTrans()<CR>'
    exe "imenu  <silent>  ".s:Run.'.&pcal<Tab>\F7                               <C-C>:call TLA_PcalTrans()<CR>'
    exe "amenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ pcal<Tab>\F8           :call TLA_PcalTransArguments()<CR>'
    exe "imenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ pcal<Tab>\F8      <C-C>:call TLA_PcalTransArguments()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP3-                          :'

    exe "amenu  <silent>  ".s:Run.'.&pdflatex<Tab>\F5                               <C-C>:call TLA_Tla2Tex()<CR>'
    exe "imenu  <silent>  ".s:Run.'.&pdflatex<Tab>\F5                               <C-C>:call TLA_Tla2Tex()<CR>'
    exe "amenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ pdflatex<Tab>\F6           :call TLA_Tla2TexArguments()<CR>'
    exe "imenu  <silent>  ".s:Run.'.cmd\.\ line\ ar&g\.\ for\ pdflatex<Tab>\F6      <C-C>:call TLA_Tla2TexArguments()<CR>'
    exe "amenu  <silent>  ".s:Run.'.-SEP4-                          :'



  "
  "===============================================================================================
  "----- Menu : Comments----- --------------------------------------------------   {{{2
  "===============================================================================================
  "
  "
  "
  "
  if s:TLA_tla2sanyExist ==1
    exe "amenu  <silent>  ".s:Comments.'.line\ comment<Tab>\;cc                               :s=^\(//\)*=\\*=g<cr>:noh<cr>'
    exe "amenu  <silent>  ".s:Comments.'.cancel\ line\ comment<Tab>\;cu                          <C-C>:s=^\(\\\*\)*==g<cr>:noh<cr>'
    exe "amenu  <silent>  ".s:Comments.'.paragraph\ comment<Tab>\;qp      O(***************************************************************************)<CR>(*  *)<CR>(***************************************************************************)<ESC>k2hi'
    exe "amenu  <silent>  ".s:Comments.'.end\ line\ comment<Tab>\;qe  A    \*'
    exe "amenu  <silent>  ".s:Comments.'.-SEP1-                          :'
  endif

  "


  "
  "===============================================================================================
  "----- Menu : help  -------------------------------------------------------   {{{2
  "===============================================================================================
  "
  if s:TLA_Root != ""
    exe " menu  <silent>  ".s:TLA_Root.'&help\ (TLA+-Support)<Tab>\\hp        :call TLA_HelpTLAsupport()<CR>'
    exe "imenu  <silent>  ".s:TLA_Root.'&help\ (TLA+-Support)<Tab>\\hp   <C-C>:call TLA_HelpTLAsupport()<CR>'
  endif

endfunction    " ----------  end of function  TLA_InitMenus  ----------

"
" ---------- hot keys ------------------------------------------
"
" ---------- statement menu ----------------------------------------------------
"
noremap  <buffer>  <silent>  <Leader>gi           :call TLA_InsertTemplate("statements.IF-THEN-ELSE")<CR>
noremap  <buffer>  <silent>  <Leader>ga          :call TLA_InsertTemplate("statements.CASE")<CR>
noremap  <buffer>  <silent>  <Leader>go           :call TLA_InsertTemplate("statements.CASE-OTHER")<CR>
noremap  <buffer>  <silent>  <Leader>glc          :call TLA_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>
noremap  <buffer>  <silent>  <Leader>gld           :call TLA_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>

inoremap  <buffer>  <silent>  <Leader>gi           :call TLA_InsertTemplate("statements.IF-THEN-ELSE")<CR>
inoremap  <buffer>  <silent>  <Leader>ga          :call TLA_InsertTemplate("statements.CASE")<CR>
inoremap  <buffer>  <silent>  <Leader>go           :call TLA_InsertTemplate("statements.CASE-OTHER")<CR>
inoremap  <buffer>  <silent>  <Leader>glc          :call TLA_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>
inoremap  <buffer>  <silent>  <Leader>gld           :call TLA_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>


vnoremap  <buffer>  <silent>  <Leader>gi           :call TLA_InsertTemplate("statements.IF-THEN-ELSE")<CR>
vnoremap  <buffer>  <silent>  <Leader>ga          :call TLA_InsertTemplate("statements.CASE")<CR>
vnoremap  <buffer>  <silent>  <Leader>go           :call TLA_InsertTemplate("statements.CASE-OTHER")<CR>
vnoremap  <buffer>  <silent>  <Leader>glc          :call TLA_InsertTemplate("statements.LET-IN-CONJUNCTION")<CR>
vnoremap  <buffer>  <silent>  <Leader>gld           :call TLA_InsertTemplate("statements.LET-IN-DISJUNCTION")<CR>

"
" ---------- snippets  menu ----------------------------------------------------
"
noremap  <buffer>  <silent>  <LocalLeader>sf           :call  TLA_InsertTemplate("tla.frame")<CR>
inoremap  <buffer>  <silent>  <LocalLeader>sf           :call  TLA_InsertTemplate("tla.frame")<CR>
vnoremap  <buffer>  <silent>  <LocalLeader>sf           :call  TLA_InsertTemplate("tla.frame")<CR>

"
" ---------- help menu ----------------------------------------------------
"
noremap  <buffer>  <silent>  <LocalLeader>hp           :call TLA_HelpTLAsupport()<CR>
inoremap  <buffer>  <silent>  <LocalLeader>hp           :call TLA_HelpTLAsupport()<CR>
vnoremap  <buffer>  <silent>  <LocalLeader>hp           :call TLA_HelpTLAsupport()<CR>



"
" ---------- Go Defination ----------------------------------------------------
"
noremap  <buffer>  <silent>  <LocalLeader>gd           :call TLA_GoDefination()<CR>
inoremap  <buffer>  <silent>  <LocalLeader>gd           :call TLA_GoDefination()<CR>
vnoremap  <buffer>  <silent>  <LocalLeader>gd           :call TLA_GoDefination()<CR>



if !exists("g:TLA_Ctrl_j") || ( exists("g:TLA_Ctrl_j") && g:TLA_Ctrl_j != 'off' )
  nmap    <buffer>  <silent>  <C-j>   i<C-R>=TLA_JumpCtrlJ()<CR>
  imap    <buffer>  <silent>  <C-j>    <C-R>=TLA_JumpCtrlJ()<CR>
endif

"jump to defination
function! TLA_GoDefination(  )
	let s:cuc		= getline(".")[col(".") - 1]		" character under the cursor
	let	s:item	= expand("<cword>")							" word under the cursor
	let	s:item	='^\(\s*\)\@='.s:item.'\s*==' 
  silent call search(s:item, 'w')
  normal! zz 
endfunction

"
function! TLA_Indent(  )
  let s:line  = line()
  let s:line_prev  = s:line - 1 
  let s:indent = indent(s:line_prev)  
endfunction





"------------------------------------------------------------------------------
"  TLA_CreateGuiMenus     {{{1
"------------------------------------------------------------------------------
let s:TLA_MenuVisible = 0								" state variable controlling the C-menus
"
function! TLA_CreateGuiMenus ()
  if s:TLA_MenuVisible != 1
    aunmenu <silent> &Tools.Load\ TLA+\ Support
    amenu   <silent> 60.1000 &Tools.-SEP100- :
    amenu   <silent> 60.1030 &Tools.Unload\ TLA+\ Support <C-C>:call TLA_RemoveGuiMenus()<CR>
    call TLA_InitMenus()
    let s:TLA_MenuVisible = 1
  endif
endfunction    " ----------  end of function TLA_CreateGuiMenus  ----------

"------------------------------------------------------------------------------
"  TLA_ToolMenu     {{{1
"------------------------------------------------------------------------------
function! TLA_ToolMenu ()
  amenu   <silent> 60.1000 &Tools.-SEP100- :
  amenu   <silent> 60.1030 &Tools.Load\ TLA+\ Support      :call TLA_CreateGuiMenus()<CR>
  imenu   <silent> 60.1030 &Tools.Load\ TLA+\ Support <C-C>:call TLA_CreateGuiMenus()<CR>
endfunction    " ----------  end of function TLA_ToolMenu  ----------

"------------------------------------------------------------------------------
"  TLA_RemoveGuiMenus     {{{1
"------------------------------------------------------------------------------
function! TLA_RemoveGuiMenus ()
  if s:TLA_MenuVisible == 1
    if s:TLA_Root == ""
      aunmenu <silent> Operator
      aunmenu <silent> Constructs
      aunmenu <silent> Run
    else
      exe "aunmenu <silent> ".s:TLA_Root
    endif
    "
    aunmenu <silent> &Tools.Unload\ TLA+\ Support
    call TLA_ToolMenu()
    "
    let s:TLA_MenuVisible = 0
  endif
endfunction    " ----------  end of function TLA_RemoveGuiMenus  ----------

if has("gui_running")
  "
  call TLA_ToolMenu()
  "
  if s:TLA_LoadMenus == 'yes'
    call TLA_CreateGuiMenus()
  endif
  "
  " nmap  <unique>  <silent>  <Leader>lcs   :call TLA_CreateGuiMenus()<CR>
  " nmap  <unique>  <silent>  <Leader>ucs   :call TLA_RemoveGuiMenus()<CR>
  "
endif



"
"------------------------------------------------------------------------------
"  TLA_Input: Input after a highlighted prompt     {{{1
"------------------------------------------------------------------------------
function! TLA_Input ( promp, text, ... )
  echohl Search																					" highlight prompt
  call inputsave()																			" preserve typeahead
  if a:0 == 0 || a:1 == ''
    let retval	=input( a:promp, a:text )
  else
    let retval	=input( a:promp, a:text, a:1 )
  endif
  call inputrestore()																		" restore typeahead
  echohl None																						" reset highlighting
  let retval  = substitute( retval, '^\s\+', "", "" )		" remove leading whitespaces
  let retval  = substitute( retval, '\s\+$', "", "" )		" remove trailing whitespaces
  return retval
endfunction    " ----------  end of function TLA_Input ----------

"tla2sany.SANY
let s:TLA_Tla2SanyCmdLineArgs = ''

function! TLA_Tla2sanyArguments ()
  let	s:TLA_Tla2SanyCmdLineArgs= TLA_Input(" command line arguments : ",s:TLA_Tla2SanyCmdLineArgs )
  call TLA_Tla2sany()
endfunction    " ----------  end of function TLA_Tla2sanyArguments ----------

function! TLA_Tla2sany()
  " update : write source file if necessary
  exec	":update"
  " run tla2sany.SANY  
  exec	":!java -cp ".g:TLA_PATH." tla2sany.SANY  ".s:TLA_Tla2SanyCmdLineArgs." %<"	
endfunction    " ----------  end of function TLA_Tla2sany----------


"
let s:TLA_Tlc2CmdLineArgs = ''

function! TLA_Tlc2Arguments ()
  let	s:TLA_Tlc2CmdLineArgs = TLA_Input(" command line arguments : ",s:TLA_Tlc2CmdLineArgs )
  call TLA_Tlc2()
endfunction    " ----------  end of function TLA_Tla2sanyArguments ----------

function! TLA_Tlc2()
  " update : write source file if necessary
  exec	":update"
  " run tlc2.TLC  
  exec	":!java -cp ".g:TLA_PATH." tlc2.TLC  ".s:TLA_Tlc2CmdLineArgs." %<"	
endfunction    " ----------  end of function TLA_Tlc2----------

"pcal.trans
let s:TLA_PcalTransCmdLineArgs = ''

function! TLA_PcalTransArguments ()
  let	s:TLA_PcalTransCmdLineArgs = TLA_Input(" command line arguments : ",s:TLA_PcalTransCmdLineArgs )
  call TLA_PcalTrans()
endfunction    " ----------  end of function TLA_PcalTransArguments ----------

function! TLA_PcalTrans()
  " update : write source file if necessary
  exec	":update"
  " run pcal.trans
  exec	":!java -cp ".g:TLA_PATH." pcal.trans ".s:TLA_PcalTransCmdLineArgs ." %<"	
endfunction    " ----------  end of function TLA_PcalTrans----------


" command! TLA_Tla2Tex call TLA_Tla2Tex()
function! TLA_Tla2Tex()
  " w!
  " update : write source file if necessary
  exec	":update"
  " run tla2tex.TLA
  " " !java tla2tex.TLA -latexCommand pdflatex -ptSize 12 % 
  exec	":!java -cp ".g:TLA_PATH." tla2tex.TLA -latexCommand pdflatex ".s:TLA_Tla2TexCmdLineArgs." %"
  if s:MSWIN
     " !cd %:p:h 
   !AcroRd32  %:p:r.pdf 
  else
    silent !evince %:r.pdf &
  endif
endfunction
"
let s:TLA_Tla2TexCmdLineArgs = ''

function! TLA_Tla2TexArguments ()
  let	s:TLA_Tla2TexCmdLineArgs = TLA_Input(" command line arguments : ",s:TLA_Tla2TexCmdLineArgs )
  call TLA_Tla2Tex()
endfunction    " ----------  end of function TLA_Tla2sanyArguments ----------



"------------------------------------------------------------------------------
"  TLA_InsertTemplate     {{{1
"  insert a template from the template dictionary
"  do macro expansion
"------------------------------------------------------------------------------
function! TLA_InsertTemplate ( key, ... )

  " if !has_key( s:TLA_Template[s:TLA_ActualStyle], a:key ) &&
  " \  !has_key( s:TLA_Template['default'], a:key )
  " echomsg "style '".a:key."' / template '".a:key
  " \        ."' not found. Please check your template file in '".s:TLA_GlobalTemplateDir."'"
  " return
  " endif

  if &foldenable
    let	foldmethod_save	= &foldmethod
    set foldmethod=manual
  endif
  "------------------------------------------------------------------------------
  "  insert the user macros
  "------------------------------------------------------------------------------

  " use internal formatting to avoid conficts when using == below
  "
  let	equalprg_save	= &equalprg
  set equalprg=

  let mode  = s:TLA_Attribute[a:key]

  " remove <SPLIT> and insert the complete macro
  "
  if a:0 == 0
    let val = TLA_ExpandUserMacros (a:key)
    if val	== ""
      return
    endif
    let val	= TLA_ExpandSingleMacro( val, '<SPLIT>', '' )

    if mode == 'below'
      call TLA_OpenFold('below')
      let pos1  = line(".")+1
      put  =val
      let pos2  = line(".")
      " proper indenting
      exe ":".pos1
      let ins	= pos2-pos1+1
      exe "normal ".ins."=="
      "
    elseif mode == 'above'
      let pos1  = line(".")
      put! =val
      let pos2  = line(".")
      " proper indenting
      exe ":".pos1
      let ins	= pos2-pos1+1
      exe "normal ".ins."=="
      "
    elseif mode == 'start'
      normal gg
      call TLA_OpenFold('start')
      let pos1  = 1
      put! =val
      let pos2  = line(".")
      " proper indenting
      exe ":".pos1
      let ins	= pos2-pos1+1
      exe "normal ".ins."=="
      "
    elseif mode == 'append'
      if &foldenable && foldclosed(".") >= 0
        echohl WarningMsg | echomsg s:MsgInsNotAvail  | echohl None
        exe "set foldmethod=".foldmethod_save
        return
      else
        let pos1  = line(".")
        put =val
        let pos2  = line(".")-1
        exe ":".pos1
        :join!
      endif
      "
    elseif mode == 'insert'
      if &foldenable && foldclosed(".") >= 0
        echohl WarningMsg | echomsg s:MsgInsNotAvail  | echohl None
        exe "set foldmethod=".foldmethod_save
        return
      else
        let val   = substitute( val, '\n$', '', '' )
        let currentline	= getline( "." )
        let pos1  = line(".")
        let pos2  = pos1 + count( split(val,'\zs'), "\n" )
        " assign to the unnamed register "" :
        let @"=val
        normal p
        " reformat only multiline inserts and previously empty lines
        if pos2-pos1 > 0 || currentline =~ ''
          exe ":".pos1
          let ins	= pos2-pos1+1
          exe "normal ".ins."=="
        endif
      endif
      "
    endif
    "
  else
    "
    " =====  visual mode  ===============================
    "
    if  a:1 == 'v'
      let val = TLA_ExpandUserMacros (a:key)
      let val	= TLA_ExpandSingleMacro( val, s:TLA_TemplateJumpTarget2, '' )
      if val	== ""
        return
      endif

      if match( val, '<SPLIT>\s*\n' ) >= 0
        let part	= split( val, '<SPLIT>\s*\n' )
      else
        let part	= split( val, '<SPLIT>' )
      endif

      if len(part) < 2
        let part	= [ "" ] + part
        echomsg '<SPLIT> missing in template '.a:key
      endif
      "
      " 'visual' and mode 'insert':
      "   <part0><marked area><part1>
      " part0 and part1 can consist of several lines
      "
      if mode == 'insert'
        let pos1  = line(".")
        let pos2  = pos1
        let	string= @*
        let replacement	= part[0].string.part[1]
        " remove trailing '\n'
        let replacement   = substitute( replacement, '\n$', '', '' )
        exe ':s/'.string.'/'.replacement.'/'
      endif
      "
      " 'visual' and mode 'below':
      "   <part0>
      "   <marked area>
      "   <part1>
      " part0 and part1 can consist of several lines
      "
      if mode == 'below'

        :'<put! =part[0]
        :'>put  =part[1]

        let pos1  = line("'<") - len(split(part[0], '\n' ))
        let pos2  = line("'>") + len(split(part[1], '\n' ))
        ""			echo part[0] part[1] pos1 pos2
        "			" proper indenting
        exe ":".pos1
        let ins	= pos2-pos1+1
        exe "normal ".ins."=="
      endif
      "
    endif		" ---------- end visual mode
  endif

  " restore formatter programm
  let &equalprg	= equalprg_save

  "------------------------------------------------------------------------------
  "  position the cursor
  "------------------------------------------------------------------------------
  exe ":".pos1
  let mtch = search( '<CURSOR>', 'c', pos2 )
  if mtch != 0
    let line	= getline(mtch)
    if line =~ '<CURSOR>$'
      call setline( mtch, substitute( line, '<CURSOR>', '', '' ) )
      if  a:0 != 0 && a:1 == 'v' && getline(".") =~ '^\s*$'
        normal J
      else
        :startinsert!
      endif
    else
      call setline( mtch, substitute( line, '<CURSOR>', '', '' ) )
      :startinsert
    endif
  else
    " to the end of the block; needed for repeated inserts
    if mode == 'below'
      exe ":".pos2
    endif
  endif

  "------------------------------------------------------------------------------
  "  marked words
  "------------------------------------------------------------------------------
  " define a pattern to highlight
  call TLA_HighlightJumpTargets ()

  if &foldenable
    " restore folding method
    exe "set foldmethod=".foldmethod_save
    normal zv
  endif

endfunction    " ----------  end of function TLA_InsertTemplate  ----------



"------------------------------------------------------------------------------
" TLA_OpenFold     {{{1
" Open fold and go to the first or last line of this fold.
"------------------------------------------------------------------------------
function! TLA_OpenFold ( mode )
  if foldclosed(".") >= 0
    " we are on a closed  fold: get end position, open fold, jump to the
    " last line of the previously closed fold
    let	foldstart	= foldclosed(".")
    let	foldend		= foldclosedend(".")
    normal zv
    if a:mode == 'below'
      exe ":".foldend
    endif
    if a:mode == 'start'
      exe ":".foldstart
    endif
  endif
endfunction    " ----------  end of function TLA_OpenFold  ----------

"
"------------------------------------------------------------------------------
"  TLA_ReadTemplates     {{{1
"  read the template file(s), build the macro and the template dictionary
"
"------------------------------------------------------------------------------
let	s:style			= 'default'
function! TLA_ReadTemplates ( templatefile )

  if !filereadable( a:templatefile )
    echohl WarningMsg
    echomsg "TLA Support template file '".a:templatefile."' does not exist or is not readable"
    echohl None
    return
  endif

  let	skipmacros	= 0
  let s:TLA_FileVisited  += [a:templatefile]

  "------------------------------------------------------------------------------
  "  read template file, start with an empty template dictionary
  "------------------------------------------------------------------------------

  let item  		= ''
  let	skipline	= 0
  for line in readfile( a:templatefile )
    " if not a comment :
    if line !~ s:TLA_MacroCommentRegex
      "
      "-------------------------------------------------------------------------------
      " IF |STYLE| IS ...
      "-------------------------------------------------------------------------------
      "
      let string  = matchlist( line, s:TLA_TemplateIf )
      if !empty(string) 
        if !has_key( s:TLA_Template, string[1] )
          " new s:style
          let	s:style	= string[1]
          let	s:TLA_Template[s:style]	= {}
          continue
        endif
      endif
      "
      "-------------------------------------------------------------------------------
      " ENDIF
      "-------------------------------------------------------------------------------
      "
      let string  = matchlist( line, s:TLA_TemplateEndif )
      if !empty(string)
        let	s:style	= 'default'
        continue
      endif
      "
      "-------------------------------------------------------------------------------
      " macros and file includes
      "-------------------------------------------------------------------------------
      "
      let string  = matchlist( line, s:TLA_MacroLineRegex )
      if !empty(string) && skipmacros == 0
        let key = '|'.string[1].'|'
        let val = string[2]
        let val = substitute( val, '\s\+$', '', '' )
        let val = substitute( val, "[\"\']$", '', '' )
        let val = substitute( val, "^[\"\']", '', '' )
        "
        if key == '|includefile|' && count( s:TLA_FileVisited, val ) == 0
          let path   = fnamemodify( a:templatefile, ":p:h" )
          call TLA_ReadTemplates( path.'/'.val )    " recursive call
        else
          let s:TLA_Macro[key] = escape( val, '&' )
        endif
        continue                                     " next line
      endif
      "
      " template header
      "
      let name  = matchstr( line, s:TLA_TemplateLineRegex )
      "
      if name != ''
        " start with a new template
        let part  = split( name, '\s*==\s*')
        let item  = part[0]
        if has_key( s:TLA_Template[s:style], item ) && s:TLA_TemplateOverwrittenMsg == 'yes'
          echomsg "style '".s:style."' / existing TLA Support template '".item."' overwritten"
        endif
        let s:TLA_Template[s:style][item] = ''
        let skipmacros	= 1
        "
        " let s:TLA_Attribute[item] = 'below'
        let s:TLA_Attribute[item] = 'insert'
        " let s:TLA_Attribute[item] = 'append'
        " let s:TLA_Attribute[item] = 'below'
        if has_key( s:Attribute, get( part, 1, 'NONE' ) )
          let s:TLA_Attribute[item] = part[1]
        endif
      else
        " add to a template 
        if item != ''
          let s:TLA_Template[s:style][item] .= line."\n"
        endif
      endif
    endif
  endfor " ----- readfile -----
  let s:TLA_ActualStyle	= 'default'
  if s:TLA_Macro['|STYLE|'] != ''
    let s:TLA_ActualStyle	= s:TLA_Macro['|STYLE|']
  endif
  let s:TLA_ActualStyleLast	= s:TLA_ActualStyle
endfunction    " ----------  end of function TLA_ReadTemplates  ----------


"------------------------------------------------------------------------------
"  TLA_RereadTemplates     {{{1
"  rebuild commands and the menu from the (changed) template file
"------------------------------------------------------------------------------
function! TLA_RereadTemplates ( msg )
  let s:style							= 'default'
  let s:TLA_Template     = { 'default' : {} }
  let s:TLA_FileVisited  = []
  let	messsage							= ''
  "
  if s:installation == 'system'
    "
    if filereadable( s:TLA_GlobalTemplateFile )
      call TLA_ReadTemplates( s:TLA_GlobalTemplateFile )
    else
      echomsg "Global template file '".s:TLA_GlobalTemplateFile."' not readable."
      return
    endif
    let	messsage	= "Templates read from '".s:TLA_GlobalTemplateFile."'"
    "
    if filereadable( s:TLA_LocalTemplateFile )
      call TLA_ReadTemplates( s:TLA_LocalTemplateFile )
      let messsage	= messsage." and '".s:TLA_LocalTemplateFile."'"
    endif
    "
  else
    "
    if filereadable( s:TLA_LocalTemplateFile )
      call TLA_ReadTemplates( s:TLA_LocalTemplateFile )
      let	messsage	= "Templates read from '".s:TLA_LocalTemplateFile."'"
    else
      echomsg "Local template file '".s:TLA_LocalTemplateFile."' not readable." 
      return
    endif
    "
  endif
  if a:msg == 'yes'
    echomsg messsage.'.'
  endif

endfunction    " ----------  end of function TLA_RereadTemplates  ----------




"------------------------------------------------------------------------------
"  TLA_ExpandUserMacros     {{{1
"------------------------------------------------------------------------------
function! TLA_ExpandUserMacros ( key )

  if has_key( s:TLA_Template[s:TLA_ActualStyle], a:key )
    let template 								= s:TLA_Template[s:TLA_ActualStyle][ a:key ]
  else
    let template 								= s:TLA_Template['default'][ a:key ]
  endif
  let	s:TLA_ExpansionCounter	= {}										" reset the expansion counter

  "------------------------------------------------------------------------------
  "  renew the predefined macros and expand them
  "  can be replaced, with e.g. |?DATE|
  "------------------------------------------------------------------------------
  let	s:TLA_Macro['|BASENAME|']	= toupper(expand("%:t:r"))
  let s:TLA_Macro['|DATE|']  		= TLA_DateAndTime('d')
  let s:TLA_Macro['|FILENAME|']	= expand("%:t")
  let s:TLA_Macro['|PATH|']  		= expand("%:p:h")
  let s:TLA_Macro['|SUFFIX|']		= expand("%:e")
  let s:TLA_Macro['|TIME|']  		= TLA_DateAndTime('t')
  let s:TLA_Macro['|YEAR|']  		= TLA_DateAndTime('y')

  "------------------------------------------------------------------------------
  "  delete jump targets if mapping for C-j is off
  "------------------------------------------------------------------------------
  if s:TLA_Ctrl_j == 'off'
    let template	= substitute( template, s:TLA_TemplateJumpTarget1.'\|'.s:TLA_TemplateJumpTarget2, '', 'g' )
  endif

  "------------------------------------------------------------------------------
  "  look for replacements
  "------------------------------------------------------------------------------
  while match( template, s:TLA_ExpansionRegex ) != -1
    let macro				= matchstr( template, s:TLA_ExpansionRegex )
    let replacement	= substitute( macro, '?', '', '' )
    let template		= substitute( template, macro, replacement, "g" )

    let match	= matchlist( macro, s:TLA_ExpansionRegex )

    if match[1] != ''
      let macroname	= '|'.match[1].'|'
      "
      " notify flag action, if any
      let flagaction	= ''
      if has_key( s:TLA_MacroFlag, match[2] )
        let flagaction	= ' (-> '.s:TLA_MacroFlag[ match[2] ].')'
      endif
      "
      " ask for a replacement
      if has_key( s:TLA_Macro, macroname )
        let	name	= TLA_Input( match[1].flagaction.' : ', TLA_ApplyFlag( s:TLA_Macro[macroname], match[2] ) )
      else
        let	name	= TLA_Input( match[1].flagaction.' : ', '' )
      endif
      if name == ""
        return ""
      endif
      "
      " keep the modified name
      let s:TLA_Macro[macroname]  			= TLA_ApplyFlag( name, match[2] )
    endif
  endwhile

  "------------------------------------------------------------------------------
  "  do the actual macro expansion
  "  loop over the macros found in the template
  "------------------------------------------------------------------------------
  while match( template, s:TLA_NonExpansionRegex ) != -1

    let macro			= matchstr( template, s:TLA_NonExpansionRegex )
    let match			= matchlist( macro, s:TLA_NonExpansionRegex )

    if match[1] != ''
      let macroname	= '|'.match[1].'|'

      if has_key( s:TLA_Macro, macroname )
        "-------------------------------------------------------------------------------
        "   check for recursion
        "-------------------------------------------------------------------------------
        if has_key( s:TLA_ExpansionCounter, macroname )
          let	s:TLA_ExpansionCounter[macroname]	+= 1
        else
          let	s:TLA_ExpansionCounter[macroname]	= 0
        endif
        if s:TLA_ExpansionCounter[macroname]	>= s:TLA_ExpansionLimit
          echomsg "recursion terminated for recursive macro ".macroname
          return template
        endif
        "-------------------------------------------------------------------------------
        "   replace
        "-------------------------------------------------------------------------------
        let replacement = TLA_ApplyFlag( s:TLA_Macro[macroname], match[2] )
        let template 		= substitute( template, macro, replacement, "g" )
      else
        "
        " macro not yet defined
        let s:TLA_Macro['|'.match[1].'|']  		= ''
      endif
    endif

  endwhile

  return template
endfunction    " ----------  end of function TLA_ExpandUserMacros  ----------

"
"------------------------------------------------------------------------------
"  TLA_ExpandSingleMacro     {{{1
"------------------------------------------------------------------------------
function! TLA_ExpandSingleMacro ( val, macroname, replacement )
  return substitute( a:val, escape(a:macroname, '$' ), a:replacement, "g" )
endfunction    " ----------  end of function TLA_ExpandSingleMacro  ----------



"------------------------------------------------------------------------------
"  TLA_HighlightJumpTargets
"------------------------------------------------------------------------------
function! TLA_HighlightJumpTargets ()
  if s:TLA_Ctrl_j == 'on'
    exe 'match Search /'.s:TLA_TemplateJumpTarget1.'\|'.s:TLA_TemplateJumpTarget2.'/'
  endif
endfunction    " ----------  end of function TLA_HighlightJumpTargets  ----------




"------------------------------------------------------------------------------
"  TLA_JumpCtrlJ     {{{1
"------------------------------------------------------------------------------
function! TLA_JumpCtrlJ ()
  let match	= search( s:TLA_TemplateJumpTarget1.'\|'.s:TLA_TemplateJumpTarget2, 'c' )
  if match > 0
    " remove the target
    call setline( match, substitute( getline('.'), s:TLA_TemplateJumpTarget1.'\|'.s:TLA_TemplateJumpTarget2, '', '' ) )
  else
    " try to jump behind parenthesis or strings in the current line
    if match( getline(".")[col(".") - 1], "[\]})\"'`]"  ) != 0
      call search( "[\]})\"'`]", '', line(".") )
    endif
    normal l
  endif
  return ''
endfunction    " ----------  end of function TLA_JumpCtrlJ  ----------


"------------------------------------------------------------------------------
"  generate date and time     {{{1
"------------------------------------------------------------------------------
function! TLA_DateAndTime ( format )
  if a:format == 'd'
    return strftime( s:TLA_FormatDate )
  elseif a:format == 't'
    return strftime( s:TLA_FormatTime )
  elseif a:format == 'dt'
    return strftime( s:TLA_FormatDate ).' '.strftime( s:TLA_FormatTime )
  elseif a:format == 'y'
    return strftime( s:TLA_FormatYear )
  endif
endfunction    " ----------  end of function TLA_DateAndTime  ----------


"
"------------------------------------------------------------------------------
"  Run : help tlasupport     {{{1
"------------------------------------------------------------------------------
function! TLA_HelpTLAsupport ()
  try
    :help tlasupport
  catch
    exe ':helptags '.s:plugin_dir.'doc'
    :help tlasupport
  endtry
endfunction    " ----------  end of function TLA_HelpTLAsupport ----------




"
"------------------------------------------------------------------------------
"  READ THE TEMPLATE FILES
"------------------------------------------------------------------------------
call TLA_RereadTemplates('no')
"

" ---------------------------------------for TLA+------------------------------------
"highlight keywords
syn keyword tlaStatement		 CASE  OTHER  IF THEN  ELSE  LET IN
syn keyword tlaBoolean		TRUE FALSE 		
syn keyword tlaNormalOperator	CHOOSE SUBSET UNION DOMAIN EXCEPT  ENABLE  ENABLED UNCHANGED 	 
"
syn keyword tlaModule		Naturals Integers Reals Sequences FiniteSets Bags RealTime TLC 
syn keyword tlaFunc Nat Real Int Infinity Head SelectSeq SubSeq Append Len Seq Tail IsFiniteSet Cardinality 	BagCardinality BagIn BagOfAll BagToSet BagUnion CopiesIn EmptyBag IsABag SetToBag SubBag RTBound RTnow now Print PrintT Assert JavaTime Permutations SortSeq 

syn keyword tlaLabel	EXTENDS THEOREM ASSUME  WITH INSTANCE  
syn keyword tlaConstant MODULE	
syn keyword tlaType  CONSTANTS CONSTANT  VARIABLES VARIABLE  BOOLEAN STRING  

syn keyword tla2Keyword  ACTION HAVE PICK SUFFICES ASSUMPTION HIDE PROOF TAKE AXIOM LAMBDA PROPOSITION TEMPORAL BY LEMMA PROVE USE COROLLARY NEW QED WITNESS DEF OBVIOUS RECURSIVE DEFINE OMITTED STATE DEFS

syntax region tlaString  start=/"/ skip=/\\"/ end=/"/
syntax match tlaComment /(\*\(.\)*\*)/
" syntax match tlaComment /(\*\(\_.\)*\*)/
" syntax match tlaComment /(\*\(.\)*\*)/
syntax match tlaSlashComment /\\\*.*/
syntax match tlaTuple /{[^}]*}/
syntax match tlaSlashOperator /\\circ/ 
syntax match tlaSlashOperator /\\div/ 
syntax match tlaSlashOperator /\\oplus/ 
syntax match tlaSlashOperator /\\ominus/ 
syntax match tlaSlashOperator /\\otimes/ 
syntax match tlaSlashOperator /\\oslash/ 
syntax match tlaSlashOperator /\\odot/ 
syntax match tlaSlashOperator /\\geq/ 
syntax match tlaSlashOperator /\\leq/ 
syntax match tlaSlashOperator /\\sqcap/ 
syntax match tlaSlashOperator /\\prec/ 
syntax match tlaSlashOperator /\\succ/ 
syntax match tlaSlashOperator /\\preceq/ 
syntax match tlaSlashOperator /\\succeq/ 
syntax match tlaSlashOperator /\\sqcup/ 
syntax match tlaSlashOperator /\\ll/ 
syntax match tlaSlashOperator /\\gg/ 
syntax match tlaSlashOperator /\\subset/ 
syntax match tlaSlashOperator /\\supset/ 
syntax match tlaSlashOperator /\\subseteq/ 
syntax match tlaSlashOperator /\\supseteq/ 
syntax match tlaSlashOperator /\\star/ 
syntax match tlaSlashOperator /\\bullet/ 
syntax match tlaSlashOperator /\\sim/ 
syntax match tlaSlashOperator /\\simeq/ 
syntax match tlaSlashOperator /\\approx/ 
syntax match tlaSlashOperator /\\cong/ 
syntax match tlaSlashOperator /\\asymp/ 
syntax match tlaSlashOperator /\\doteq/ 
syntax match tlaSlashOperator /\\propto/ 
syntax match tlaSlashOperator /\\wr/ 
syntax match tlaSlashOperator /\\uplus/ 
syntax match tlaSlashOperator /\\bigcirc/ 
syntax match tlaSlashOperator /\\lnot/ 
syntax match tlaSlashOperator /\\neg/ 
syntax match tlaSlashOperator /\\equiv/ 
syntax match tlaSlashOperator /\\land/ 
syntax match tlaSlashOperator /\\lor/ 
syntax match tlaSlashOperator /\\in/ 
syntax match tlaSlashOperator /\\notin/ 
syntax match tlaSlashOperator /\\cdot/ 
syntax match tlaSlashOperator /\\cap/ 
syntax match tlaSlashOperator /\\intersect/ 
syntax match tlaSlashOperator /\\cup/ 
syntax match tlaSlashOperator /\\union/ 
syntax match tlaSlashOperator /\\E/ 
syntax match tlaSlashOperator /\\EE/ 
syntax match tlaSlashOperator /\\X/ 
syntax match tlaSlashOperator /\\A/ 
syntax match tlaSlashOperator /\\AA/ 
syntax match tlaSlashOperator /\\sqsubset/ 
syntax match tlaSlashOperator /\\sqsupset/ 
syntax match tlaSlashOperator /\\sqsubseteq/ 
syntax match tlaSlashOperator /\\sqsupseteq/ 


" syn keyword tlaOperator            -------- ========    |
" || |- -| =|  |=  |->
syntax match tlaSingleOperator /[+|\-|*|/|%|^|>|<|$|#|,|.|&|~|!|:|'']/ 
syntax match tlaExtraOperator /[{|}|[|\]]/ 
syntax match tlaDisjunction /\\\// 
syntax match tlaConjunction /\/\\/ 
syntax match tlaEqual /=/ 
syntax match tlaEnd /=\{4,\}/ 

syn match       tlaMultiOperator  display "++"
syn match       tlaMultiOperator  display "--"
syn match       tlaMultiOperator  display ">="
syn match       tlaMultiOperator  display "<="
syn match       tlaMultiOperator  display "=<"
syn match       tlaMultiOperator  display "//"
syn match       tlaMultiOperator  display "^^"
syn match       tlaMultiOperator  display "<<"
syn match       tlaMultiOperator  display ">>"
syn match       tlaMultiOperator  display "<:"
syn match       tlaMultiOperator  display ":>"
syn match       tlaMultiOperator  display "%%"
syn match       tlaMultiOperator  display "##"
syn match       tlaMultiOperator  display "$$"
syn match       tlaMultiOperator  display ":="
syn match       tlaMultiOperator  display "::="
syn match       tlaMultiOperator  display "??"
syn match       tlaMultiOperator  display "!!"
syn match       tlaMultiOperator  display "@@"
syn match       tlaMultiOperator   /\[\]/
syn match       tlaMultiOperator  display "<>"
syn match       tlaMultiOperator  display "=>"
syn match       tlaMultiOperator  display "-+->"
syn match       tlaMultiOperator  display "<=>"
syn match       tlaMultiOperator  display "~>"
syn match       tlaMultiOperator  display "/="
syn match       tlaMultiOperator   /\[\w*\]_\(\w\)*/
syn match       tlaMultiOperator   />>_\(\w\)*/
syn match       tlaMultiOperator   /\s==\s/
syn match       tlaMultiOperator  display "<-"
syn match       tlaMultiOperator  display "&&"
syn match       tlaMultiOperator  display "|"
syn match       tlaMultiOperator  display "||"
syn match       tlaMultiOperator  display "|-"
syn match       tlaMultiOperator  display "-|"
syn match       tlaMultiOperator  display "=|"
syn match       tlaMultiOperator  display "|="
syn match       tlaMultiOperator  display "|->"
syn match       tlaMultiOperator  /WF_\(<\)\{0,2\}.*\(>\)\{0,2\}(\(.\)*)/
syn match       tlaMultiOperator  /SF_\(<\)\{0,2\}.*\(>\)\{0,2\}(\(.\)*)/
"-------------------------------- for TLA+ end--------------------------------
"
"-------------------------------- for PlusCal--------------------------------
" assert begin call do either else elsif end goto if macro or print procedure process return skip then variable variables while with await
syn keyword tlaPlusCalShareKeyword		algorithm 
syn keyword tlaPlusCalDeclaration  variable variables  
syn keyword tlaPlusCalStatment   if then else elsif while do await 
" syn keyword tlaPlusCalCSyntaxKeyword		 
syn keyword tlaPlusCalPascaSyntaxKeyword	begin end	
syn keyword tlaPlusCalReservedWods   assert    either    macro or print procedure process     with
syn keyword tlaPlusCalToDo   call goto return skip   
"-------------------------------- for PlusCal end--------------------------------



if version >= 508 
  if version < 508
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink tlaFunc			Function
  HiLink tlaBoolean			Boolean
  HiLink tlaString			String
  HiLink tlaTuple			String
  HiLink tlaModule		Constant
  HiLink tlaNormalOperator			Operator
  HiLink tlaOperator			Operator
  HiLink tlaSlashOperator			Operator
  HiLink tlaSingleOperator			Operator
  HiLink tlaStatement	Statement	
  HiLink tlaLabel			Identifier
  HiLink tlaConstant			Constant
  HiLink tlaType			Type
  HiLink tlaComment			Comment
  HiLink tlaSlashComment			Comment
  hi def  tlaDisjunction  ctermfg=LightGreen guifg=LightGreen
  hi def  tlaConjunction	ctermfg=DarkGreen guifg=DarkGreen
  hi def  tlaEqual	cterm=bold ctermfg=DarkCyan guifg=DarkCyan gui=bold
  hi tlaExtraOperator            guifg=#640404
  hi tlaEnd            guifg=#D1D1D1
  HiLink tlaMultiOperator			Operator
  HiLink tla2Keyword        Keyword



  " HiLink tlaPlusCalCSyntaxKeyword  Operator
  hi def tlaPlusCalPascaSyntaxKeyword term=bold ctermfg=DarkRed cterm=bold gui=bold guifg=Brown

  hi def tlaPlusCalShareKeyword  ctermfg=DarkMagenta guifg=#404010
  hi def tlaPlusCalReservedWods  ctermfg=DarkCyan cterm=NONE guifg=#106060
  hi def tlaPlusCalStatment term=bold ctermfg=DarkRed cterm=bold gui=bold guifg=Brown
  hi def tlaPlusCalToDo term=standout ctermfg=DarkBlue ctermbg=Yellow guifg=Blue guibg=Yellow
  hi def tlaPlusCalDeclaration term=underline ctermfg=DarkGreen gui=bold guifg=SeaGreen
  
  delcommand HiLink
endif

" F3 for comment
nmap <F3> :s=^\(//\)*=\\*=g<cr>:noh<cr>
" block comment
if s:MSWIN
  nmap <leader>qb <C-q><C-d>I \*<ESC> 
else 
  nmap <leader>qb <C-v><C-d>I \*<ESC> 
endif
" add comment at the end of line
nmap <leader>qe A    \*
nmap <leader>qd t*d$<ESC>    
function! TLA_CancelEndOfLineComment()
  lineNum = getline(.)
  " columNum = match()
	let [lnum, col] = searchpos('*', 'lineNum')
endfunction    " ----------  end of function TLA_EndOfLineComment ----------
" paragraph comment
nmap <leader>qp O(***************************************************************************)<CR>(**)<CR>(***************************************************************************)<ESC>khi 


" F4 for uncomment
nmap <F4> :s=^\(\\\*\)*==g<cr>:noh<cr>

"abbrs
iab ---- <c-r>=("----------------------------------------------------------------------------------")<cr>
iab ==== <c-r>=("==================================================================================")<cr>
iab mn <c-r>= expand("%:r")

" map <F8> :call TLA_GoDefination()<CR>
map <F5> :call TLA_Tla2Tex()<CR>
map <F6> :call TLA_Tla2TexArguments()<CR>
map <F7> :call TLA_PcalTrans()<CR>
map <F8> :call TLA_PcalTransArguments()<CR>
map <F9> :call TLA_Tla2sany()<CR>
map <F10> :call TLA_Tla2sanyArguments()<CR>
map <F11> :call TLA_Tlc2()<CR>
map <F12> :call TLA_Tlc2Arguments()<CR>
map <leader>cc :s=^\(//\)*=\\*=g<cr>:noh<cr>
map <leader>cu :s=^\(\\\*\)*==g<cr>:noh<cr>

let b:current_syntax = "tla"

