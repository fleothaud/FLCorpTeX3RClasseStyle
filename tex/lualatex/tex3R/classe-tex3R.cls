\NeedsTeXFormat{LaTeX2e}[2022-11-01]

\ProvidesClass{classe-tex3R}[12/02/2024 - Version 3.3.0 de la classe-tex3R]

% ============================================================
% classe-tex3R.cls — Classe LuaLaTeX pour documents pédagogiques
%
% Prérequis : compilation LuaLaTeX obligatoire.
% Basée sur KOMA-Script (scrartcl) + style-tex3R.sty pour les valeurs
% par défaut.
%
% Point d'entrée utilisateur : \parametrage{} (ou \AtEndPreamble
% automatique).  Cette commande appelle ParametrageDocument() qui
% orchestre toutes les fonctions de configuration dans l'ordre suivant :
%
%   1. Police      : PoliceUtilisateur → PoliceDocument
%   2. Page        : FormatUtilisateur → FormatDocument
%   3. Couleurs    : CouleursUtilisateur → CouleursDocument
%   4. Logos       : LogosUtilisateur → LogosDocument
%   5. Booléens    : BooleensDocument
%   6. Styles/Titres : StylesTitresUtilisateur → StylesTitresDocument
%                      TitresUtilisateur → TitresDocument
%   7. Environnements : EnvironnementsUtilisateur → EnvironnementsDocument
%   8. Titre       : TitreLua
%
% Variables Lua globales disponibles avant \parametrage{} :
%   Type, Format, Niveau, Chapitre, Numero, Compteur, Taille,
%   Impression, Header, Correction, Enonce, Visible,
%   Bareme, Competence, Difficulte, Source, Theme, Stretch
% ============================================================

\LoadClass{scrartcl}% Classe KOMA-Script
\PassOptionsToPackage{table,svgnames}{xcolor}

\RequirePackage{iftex}
\ifluatex
  \RequirePackage{luacode}
\else
  \ClassError{Lualatex only}{Ce document doit êtres compilé en LuaLaTeX}{}\stop
\fi

\begin{luacode*}
  -- Tables Lua globales partagées entre classe-tex3R.cls et style-tex3R.sty.
  -- Chaque table regroupe les paramètres d'un domaine fonctionnel.
  -- Elles sont peuplées par les fonctions "Utilisateur" (style-tex3R.sty)
  -- puis lues par les fonctions "Document" (classe-tex3R.cls).
  PARAMETRES   = {}   -- options globales du document (type, format, flags…)
  PAGE         = {}   -- dimensions, marges, styles des sections et listes
  POLICE       = {}   -- polices texte/maths, tailles, interligne tableau
  COULEURS     = {}   -- palette de couleurs (écran vs impression)
  LOGOS        = {}   -- icônes FontAwesome par type de document
  STYLESTITRES = {}   -- variantes de titre (sans, un, deux, trois)
  TITRES       = {}   -- texte du titre et entrées TOC par type
  ENVIRONNEMENTS = {} -- code LaTeX des boîtes de cours et exercices

  PARAMETRES.premier = true    -- true uniquement au tout premier \parametrage{}
  PARAMETRES.format  = 'fiche' -- valeur par défaut si Format n'est pas défini
\end{luacode*}

%Formatage de la page et du texte
\RequirePackage{geometry}
\RequirePackage{lastpage}
\RequirePackage{silence}
\RequirePackage[np]{numprint}

\RequirePackage{pstricks}
\RequirePackage{pst-plot}
\RequirePackage{pst-eucl}
\let\clipbox\undefined
%La commande clipbox de pstricks n'est plus définie : attention à son utilisation
\RequirePackage[export]{adjustbox}

\RequirePackage{xcolor}
\RequirePackage{fontspec}
\RequirePackage{anyfontsize}
\RequirePackage[french]{babel}
\RequirePackage{enumitem}
\RequirePackage{tasks}

%Formatages divers
\RequirePackage{fontawesome5}
\RequirePackage[minimal]{lua-ul}
\RequirePackage{soul}

\RequirePackage{environ}
\RequirePackage[autoenlargeheadfoot=false]{scrlayer-scrpage}
\RequirePackage{bookmark}

\RequirePackage{etoolbox}
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage{subfiles}

\RequirePackage{ProfCollege}
  \tcbuselibrary{skins,breakable}
\RequirePackage[warnings-off={mathtools-colon,mathtools-overbracket}]{unicode-math}
\let\oldusetikzlibrary\usetikzlibrary
\renewcommand{\usetikzlibrary}[1]{%
  \ifstrequal{#1}{bending}{}{\oldusetikzlibrary{#1}}%
}
\RequirePackage{scratch3}
\catcode`\_11
\renewcommand{\turn_arrow}[1]{%
\tikz[baseline=.25ex, x=6.5ex, y=6.5ex, #1]
\draw[>=stealth, line width=1pt, postaction={decorate, decoration={markings, mark=at position 1 with {\draw (0,-0.05) -- (0,0.05)   -- (0.1,0) -- (0,-0.05) -- (0,0) -- (0.05,0) -- (0.02,0.02) -- (0.02,-0.02) -- (0.05,0);}}}](0,0) arc[start angle=-80, end angle=190, radius=1ex];%
}
\scr_restorecatcode

\RequirePackage{pgf}
\RequirePackage{pgfplots}
  \pgfplotsset{compat=1.13}
  \usetikzlibrary{arrows,calc,fit,patterns,plotmarks,shapes.geometric,shapes.misc,shapes.symbols,shapes.arrows,shapes.callouts, shapes.multipart, shapes.gates.logic.US,shapes.gates.logic.IEC, er, automata,backgrounds,chains,topaths,trees,petri,mindmap,matrix, calendar, folding,fadings,through,positioning,scopes,decorations.fractals,decorations.shapes,decorations.text,decorations.pathmorphing,decorations.pathreplacing,decorations.footprints,decorations.markings,shadows,babel}%Charge toutes les librairies de Tikz
 
\RequirePackage{pdflscape}
\RequirePackage{tabularx}
\RequirePackage{listings}

\RequirePackage{tkz-fct,tkz-tab}
\RequirePackage[lua]{tkz-euclide}
\RequirePackage{OutilsGeomTikz}

\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{mathrsfs}	
\RequirePackage{bbding}						
\RequirePackage[misc]{ifsym}
\RequirePackage{cancel}
\RequirePackage{url} 	      
\RequirePackage{fancybox}	
\RequirePackage{colortbl}
\RequirePackage{setspace}	
\RequirePackage{multirow}	
\RequirePackage{import}
\RequirePackage{qrcode}
\RequirePackage{tikzsymbols}
\RequirePackage{ccicons}
\RequirePackage{circledsteps}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SUPPRESSIONS DE WARNINGS ABUSIFS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\WarningsOff[scrlayer-scrpage]

%%%%%%%%%%%%%%%%%%%%%%
% BOOLÉENS DU FORMAT %
%%%%%%%%%%%%%%%%%%%%%%

\newif\ifdiapo
\newif\iffiche
\newif\ifheader
\newif\ifprint
\newif\ifsubfile
\newif\ifpremier
  \premiertrue

\newcommand{\FormatPage}

\begin{luacode*}

  -- FormatageString(str) — Nettoie une chaîne multi-lignes stockée dans une
  --   table Lua (supprime sauts de ligne et espaces en début/fin) avant de
  --   l'injecter dans du code LaTeX via tex.sprint().
  function FormatageString(string)
    if string ~= nil then
      newString = string.gsub(string, "\n", "")
      newString = string.gsub(newString, "^%s+", "")
      newString = string.gsub(newString, "%s+$", "")
    end
    return newString
  end

  -- RestoreHeader() — Réactive le booléen LaTeX \ifheader si le paramètre
  --   header est vrai.  Utilisé lors du chargement d'un sous-fichier (subfile).
  function RestoreHeader()
    if PARAMETRES.header then
      tex.sprint('\\headertrue')
    end
  end

  -- FormatDocument() — Génère le code LaTeX de mise en page à partir des
  --   valeurs stockées dans PAGE et PARAMETRES.
  --   Appelée par ParametrageDocument() à chaque \parametrage{}.
  --   Les blocs conditionnels "if PREMIER" ne s'exécutent qu'une seule fois.
  function FormatDocument()

    local HEADER = PARAMETRES.header
    local FORMAT = PARAMETRES.format
    local PRINT = PARAMETRES.print
    local PREMIER = PARAMETRES.premier
    local NUMERO = PARAMETRES.numero
    local CHAPITRE = PARAMETRES.chapitre
    local NIVEAU = PARAMETRES.niveau
    local COMPTEUR = PARAMETRES.compteur
    local TYPE = PARAMETRES.type

    if PREMIER then
      ChapitreLua(NUMERO)
      tex.sprint('\\renewcommand{\\contenuchapitre}{' .. CHAPITRE ..'}')

      NiveauUtilisateur(NIVEAU)
      tex.sprint('\\ifniveaucustom\\renewcommand{\\contenuniveau}{' .. NIVEAU ..'}\\fi')
    end

    if TYPE == 'DM' then
      tex.sprint('\\setcounter{compteurDM}{' .. COMPTEUR .. '}\\addtocounter{compteurDM}{-1}')
    elseif TYPE == 'DS' then
      tex.sprint('\\setcounter{compteurDS}{' .. COMPTEUR .. '}\\addtocounter{compteurDS}{-1}')
    elseif TYPE == 'interro' then
      tex.sprint('\\setcounter{compteurinterro}{' .. COMPTEUR .. '}\\addtocounter{compteurinterro}{-1}')
    elseif TYPE == 'TD' or TYPE == 'corrige' then
      tex.sprint('\\setcounter{compteurTD}{' .. COMPTEUR .. '}\\addtocounter{compteurTD}{-1}')
    elseif TYPE == 'flash' then
      tex.sprint('\\setcounter{compteurflash}{' .. COMPTEUR .. '}\\addtocounter{compteurflash}{-1}')
    end

    if PREMIER then

      -- 1) Espacement du texte
      tex.sprint(
        '\\setlength{\\parindent}{' .. FormatageString(PAGE.parindent) .. '}' ..
        '\\setlength{\\parskip}{'   .. FormatageString(PAGE.parskip)   .. '}'
      )

      -- 2) Labels des listes (itemize, enumerate, tasks)
      tex.sprint(
        '\\frenchbsetup{ItemLabeli='  .. FormatageString(PAGE.itemi)  .. '}' ..
        '\\frenchbsetup{ItemLabelii=' .. FormatageString(PAGE.itemii) .. '}' ..
        '\\setlist[enumerate,1]{label=' .. FormatageString(PAGE.enumi)  .. '}' ..
        '\\setlist[enumerate,2]{label=' .. FormatageString(PAGE.enumii) .. '}' ..
        '\\DeclareInstance{tasks}{enumerate}{default}{label =' .. FormatageString(PAGE.enumi)  .. ',label-width=1.125em}' ..
        '\\DeclareInstance{tasks}{itemize}{default}{label = '  .. FormatageString(PAGE.itemi)  .. ',label-width=1.125em}'
      )

      -- 3) Style des titres de sections (couleur, numérotation)
      tex.sprint(
        '\\renewcommand{\\stylesections}[3]{'      .. FormatageString(PAGE.stylesections)       .. '}' ..
        '\\renewcommand*{\\sectionformat}{'        .. FormatageString(PAGE.sectionnumber)        .. '}' ..
        '\\renewcommand*{\\subsectionformat}{'     .. FormatageString(PAGE.subsectionnumber)     .. '}' ..
        '\\renewcommand*{\\subsubsectionformat}{'  .. FormatageString(PAGE.subsubsectionnumber)  .. '}' ..
        '\\setkomafont{section}{'                  .. FormatageString(PAGE.sectionname)          .. '}' ..
        '\\setkomafont{subsection}{'               .. FormatageString(PAGE.subsectionname)       .. '}' ..
        '\\setkomafont{subsubsection}{'            .. FormatageString(PAGE.subsubsectionname)    .. '}'
      )

      -- 4) Format des parties et chapitres (page de garde, \part)
      tex.sprint(
        '\\renewcommand*{\\sectionlinesformat}[4]{'                             .. FormatageString(PAGE.sectionsformat)        .. '}' ..
        '\\renewcommand*\\partlineswithprefixformat[3]{\\thispagestyle{empty}'  .. FormatageString(PAGE.partformat)            .. '}' ..
        '\\renewcommand{\\formatchapitrenormal}{'                               .. FormatageString(PAGE.chapitrenormalformat)  .. '}' ..
        '\\renewcommand{\\formatchapitreetoile}{'                               .. FormatageString(PAGE.chapitreetoileformat)  .. '}'
      )

      if FORMAT =='fiche' then
        tex.sprint('\\fichetrue')
      elseif FORMAT == 'diapo' then
        tex.sprint('\\diapotrue')
      end
    end

    if PRINT then
      tex.sprint('\\printtrue')
    end

    if PREMIER then
      tex.sprint('\\newcommand{\\mygeometry}{\\geometry{paperwidth=' ..  FormatageString(PAGE.width) .. ',paperheight=' ..  FormatageString(PAGE.height) ..'}}')
    end

    tex.sprint(
          '\\newgeometry{' ..
          'top=' ..  FormatageString(PAGE.top) ..
          ',bottom=' ..  FormatageString(PAGE.bottom) ..
          ',right=' ..  FormatageString(PAGE.right) ..
          ',left=' ..  FormatageString(PAGE.left) ..
          ',includehead' ..
          ',includefoot' ..
          ',marginparsep=' ..  FormatageString(PAGE.marginparsep) ..
          ',marginparwidth=' ..  FormatageString(PAGE.marginparwidth) ..
          ',headheight=' ..  FormatageString(PAGE.headheight) ..
          ',headsep=' ..  FormatageString(PAGE.headsep) ..
          ',footskip=' ..  FormatageString(PAGE.footskip) ..
        '}' ..
        '\\savegeometry{Normal}'
    )

    tex.sprint(
      '\\newgeometry{' ..
      'top=' ..  FormatageString(PAGE.headertop) ..
      ',bottom=' ..  FormatageString(PAGE.headerbottom) ..
      ',right=' ..  FormatageString(PAGE.headerright) ..
      ',left=' ..  FormatageString(PAGE.headerleft) ..
      ',includehead' ..
      ',includefoot' ..
      ',marginparsep=' ..  FormatageString(PAGE.headermarginparsep) ..
      ',marginparwidth=' ..  FormatageString(PAGE.headermarginparwidth) ..
      ',headheight=' ..  FormatageString(PAGE.headerheadheight) ..
      ',headsep=' ..  FormatageString(PAGE.headerheadsep) ..
      ',footskip=' ..  FormatageString(PAGE.headerfootskip) ..
    '}' ..
    '\\savegeometry{Header}'
    )

    if HEADER then
      tex.sprint('\\headertrue\\loadgeometry{Header}')
      tex.sprint(
      '\\setkomafont{pagehead}{\\normalfont}' ..
      '\\ihead{\\vspace*{-1em}{\\titreactif}}' ..
        '\\ohead{}' ..
        '\\chead{}' ..        
        '\\ofoot{}' .. 
        '\\cfoot{}' ..         
        '\\ifoot{}'
      )
    else
      tex.sprint('\\loadgeometry{Normal}')
      tex.sprint(
        '\\setkomafont{pagehead}{\\normalfont}' ..
        '\\ihead{}' ..
        '\\ohead{}' ..
        '\\chead{}' ..        
        '\\ofoot{}' .. 
        '\\cfoot{}' ..         
        '\\ifoot{}' 
      )
    end

  end
\end{luacode*}

\AtBeginDocument{
  \loadgeometry{Normal}
  \npproductsign{\times}\npthousandsep{\,}\npthousandthpartsep{\,}
  }

%%%%%%%%%%%%%%%%%%%
% AUTRES BOOLÉENS %
%%%%%%%%%%%%%%%%%%%

%type
\newif\ifactivite
\newif\ifbasique
\newif\ifbilan
\newif\ifcorrige
\newif\ifcours
\newif\ifTD
\newif\ifflash
\newif\ifDM
\newif\ifDS
\newif\ifinterro

\newif\ifcorrection
\newif\ifenonce
\newif\ifvisible

\newif\ifbareme
\newif\ifdifficulte
\newif\ifcompetence
\newif\ifsource
\newif\iftheme

\newif\ifstretch

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FONCTION LUA REMPLAÇANT L'ANCIENNE FONCTION TEX PARAMETRE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{luacode*}
-- BooleensDocument() — Réinitialise tous les booléens LaTeX à false, puis
--   active ceux qui correspondent aux options courantes de PARAMETRES.
--   Doit être appelé après chaque mise à jour de PARAMETRES.
function BooleensDocument()
  local bool =[[
    \activitefalse
    \basiquefalse
    \bilanfalse
    \corrigefalse
    \coursfalse
    \flashfalse
    \TDfalse
    \DMfalse
    \DSfalse
    \interrofalse
    \flashfalse
    \baremefalse
    \correctionfalse
    \enoncefalse
    \visiblefalse
    \competencefalse
    \difficultefalse
    \sourcefalse
    \themefalse
    \stretchfalse
  ]]
  tex.sprint(FormatageString(bool))

  if PARAMETRES.type == 'activite' then
    tex.sprint('\\activitetrue')
  elseif PARAMETRES.type == 'basique' then
    tex.sprint('\\basiquetrue')
  elseif PARAMETRES.type == 'bilan' then
    tex.sprint('\\bilantrue')
  elseif PARAMETRES.type == 'corrige' then
    tex.sprint('\\corrigetrue')
  elseif PARAMETRES.type == 'cours' then
    tex.sprint('\\courstrue')
  elseif PARAMETRES.type == 'flash' then
    tex.sprint('\\flashtrue')
  elseif PARAMETRES.type == 'TD' then
    tex.sprint('\\TDtrue')
  elseif PARAMETRES.type == 'DM' then
    tex.sprint('\\DMtrue')
      elseif PARAMETRES.type == 'DS' then
    tex.sprint('\\DStrue')
  elseif PARAMETRES.type == 'interro' then
    tex.sprint('\\interrotrue')
  end

  if PARAMETRES.correction then
    tex.sprint('\\correctiontrue')
  end
  if PARAMETRES.enonce then
    tex.sprint('\\enoncetrue')
  end
    if PARAMETRES.visible then
    tex.sprint('\\visibletrue')
  end

  if PARAMETRES.bareme then
    tex.sprint('\\baremetrue')
  end
  if PARAMETRES.competence then
    tex.sprint('\\competencetrue')
  end
  if PARAMETRES.difficulte then
    tex.sprint('\\difficultetrue')
  end
  if PARAMETRES.source then
    tex.sprint('\\sourcetrue')
  end
  if PARAMETRES.theme then
    tex.sprint('\\themetrue')
  end

  if PARAMETRES.stretch then
    tex.sprint('\\stretchtrue')
  end
end
\end{luacode*}

%%%%%%%%%%%%%
% COMPTEURS %
%%%%%%%%%%%%%

%Création
\newcounter{compteurexercice}

\newcounter{compteurinterro}
\newcounter{compteurflash}
\newcounter{compteurDM}
\newcounter{compteurDS}
\newcounter{compteurTD}

%Initialisation
\setcounter{compteurexercice}{0}

\setcounter{compteurinterro}{0}
\setcounter{compteurflash}{0}
\setcounter{compteurDM}{0}
\setcounter{compteurDS}{0}
\setcounter{compteurTD}{0}

%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMANDES PERSONNELLES %
%%%%%%%%%%%%%%%%%%%%%%%%%%

%Commandes de mise en page

\begin{luacode*}
  -- TailleTexteLua(n) — Traduit un entier relatif en commande de taille LaTeX.
  --   -4=\tiny, -3=\scriptsize, -2=\footnotesize, -1=\small,
  --    0=\normalsize, 1=\large, 2=\Large, 3=\LARGE, 4=\huge
  --   Utilisé par \tailletexte{n}.
  function TailleTexteLua(nombre)
    if nombre == -4 then
      tex.sprint('\\tiny')
    elseif nombre == -3 then
      tex.sprint('\\scriptsize')
    elseif nombre == -2 then
      tex.sprint('\\footnotesize')
    elseif nombre == -1 then
      tex.sprint('\\small')
    elseif nombre == 1 then
      tex.sprint('\\large')
    elseif nombre == 2 then
      tex.sprint('\\Large')
    elseif nombre == 3 then
      tex.sprint('\\LARGE')
    elseif nombre == 4 then
      tex.sprint('\\huge') 
    else
      tex.sprint('\\normalsize')
    end
  end

  -- SautLua(str) — Génère un saut de page conditionnel selon le mode.
  --   'ligne' → saut d'une ligne, 'fiche' → newpage si mode fiche,
  --   'diapo' → newpage si mode diapo.  Utilisé par \saut{…}.
  function SautLua(arg)
    if arg == 'ligne' then
      tex.sprint('\\sautligne')
    elseif arg =='fiche' then
      tex.sprint('\\sautfiche')
    elseif arg == 'diapo' then
      tex.sprint('\\sautdiapo')
    end
  end
\end{luacode*}

\newcommand{\tailletexte}[1]{
  \directlua{TailleTexteLua(#1)}
}

\newcommand{\important}[1]{}

\newcommand{\sautligne}{\vspace{\baselineskip}}
\newcommand{\sautdiapo}{\ifdiapo \newpage \fi}
\newcommand{\sautfiche}{\iffiche \newpage \fi}
\newcommand{\saut}[1]{\directlua{SautLua("#1")}}

% \structure{titre}  — invisible dans le document, mais ajoute "titre" à la TOC
%                     (niveau subsubsection, après les enonce/correction).
% \structure*{titre} — identique mais SANS entrée dans la TOC.
\newcommand{\structurenormal}[1]{%
  \phantomsection%
  \addcontentsline{toc}{subsubsection}{#1}%
}
\newcommand{\structureetoile}[1]{}% étoile : aucun ajout à la structure

\makeatletter
\def\structure{\@ifstar\structureetoile\structurenormal}
\makeatother

%Commandes des environnements

\newcommand{\contenuchapitre}{}
\newcommand{\contenuniveau}{}

\newcommand{\contenubareme}{}
\newcommand{\contenucompetence}{}
\newcommand{\contenudifficulte}{}
\newcommand{\contenusource}{}
\newcommand{\contenutheme}{}

% Commandes de compétences — affichent l'abréviation cerclée (3 lettres).
% Usage : \competence{\Cal \Rai}  →  ⊙Cal⊙ ⊙Rai⊙
% \Circled{} (TikZ) absorbe l'espace inter-mots ; \hspace{0.3em} rétablit
% un espacement visible entre deux compétences consécutives.
\newcommand{\Com}{\Circled{Com}\hspace{0.3em}}% Communiquer
\newcommand{\Cal}{\Circled{Cal}\hspace{0.3em}}% Calculer
\newcommand{\Rep}{\Circled{Rep}\hspace{0.3em}}% Représenter
\newcommand{\Mod}{\Circled{Mod}\hspace{0.3em}}% Modéliser
\newcommand{\Rai}{\Circled{Rai}\hspace{0.3em}}% Raisonner
\newcommand{\Che}{\Circled{Che}\hspace{0.3em}}% Chercher

\begin{luacode}
  -- DifficulteLua(n) — Affiche n étoiles FontAwesome pour indiquer la difficulté.
  function DifficulteLua(nombre)
    if nombre then
      for i=1,nombre do
        tex.sprint('\\faStar')
      end
    end
  end

  -- ChapitreLua(n) — Fixe le compteur LaTeX "part" à n (numéro du chapitre).
  --   N'a d'effet que si n est une valeur non-nil non-vide.
  function ChapitreLua(nombre)
    if nombre ~= nil and nombre ~= ''  then
      tex.sprint('\\setcounter{part}{' .. nombre ..'}')
    end
  end

  -- NiveauDocument(str) — Si str est non-nil, force "contenuniveau" à str
  --   et désactive "niveaucustomtrue".  Si str est nil, active "niveaucustomtrue"
  --   pour que l'utilisateur puisse définir "contenuniveau" lui-même.
  function NiveauDocument(str)
    if str then
      tex.sprint('\\niveaucustomfalse')
      tex.sprint('\\renewcommand{\\contenuniveau}{' .. str ..'}')
    else
      tex.sprint('\\niveaucustomtrue')
    end
  end
  
  -- BaremeLua(n) — Initialise "contenubareme" à la valeur numérique n
  --   (formatée avec numprint) ou à "?" si n est nil.
  function BaremeLua(arg)
    if arg then
      tex.sprint('\\renewcommand{\\contenubareme}{\\np{' .. arg .. '}}')      
    else
      tex.sprint('\\renewcommand{\\contenubareme}{?}')
    end
  end
\end{luacode}

\newif\ifniveaucustom

\newcommand{\bareme}[1]{\directlua{BaremeLua(#1)}}
\newcommand{\competence}[1]{\renewcommand{\contenucompetence}{#1}}
\newcommand{\difficulte}[1]{\renewcommand{\contenudifficulte}{\directlua{DifficulteLua(#1)}}}
\newcommand{\source}[1]{\renewcommand{\contenusource}{#1}}
\newcommand{\theme}[1]{\renewcommand{\contenutheme}{#1}}

\newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}}%Column P centrée verticalement

%%% COMMANDES POUR LE CHAPITRE AVEC/SANS ETOILE%%%

\newcommand{\formatchapitreetoile}{}
\newcommand{\formatchapitrenormal}{}

\newif\ifpartetoile

\newcommand{\formatchapitre}{\ifpartetoile \formatchapitreetoile \else \formatchapitrenormal \fi}

\newcommand{\chapitrenormal}[1]{
  \partetoilefalse
  \part{#1}
  \renewcommand{\contenuchapitre}{#1}
}

\newcommand{\chapitreetoile}[1]{
  \partetoiletrue
  \part*{#1}
  \phantomsection\addcontentsline{toc}{part}{#1}
  \renewcommand{\contenuchapitre}{#1}
}

\newcommand{\partienormal}[1]{\subsection{#1}}
\newcommand{\partieetoile}[1]{\subsection*{#1}}
\newcommand{\souspartienormal}[1]{\subsubsection{#1}}
\newcommand{\souspartieetoile}[1]{\subsubsection*{#1}}

\makeatletter
\def\chapitre{\@ifstar\chapitreetoile\chapitrenormal}
\def\partie{\@ifstar\partieetoile\partienormal}
\def\souspartie{\@ifstar\souspartieetoile\souspartienormal}
\makeatother


%Commandes de lignes

\begin{luacode}

function LignesLua(str,nombre)
  
  if nombre == nil then
    nombre = 1
  end

  if str == 'carreaux' or str == 'carreau' then
    tex.sprint('\\tracecarreaux{' ..nombre ..'}')
  elseif str == 'surligne' then
    tex.sprint('\\tracesurligne{' ..nombre ..'}')
  else
    tex.sprint('\\tracelignes{' ..nombre ..'}')
  end

end

\end{luacode}

\newcommand{\lignes}[2]{\directlua{LignesLua("#1",#2)}}


\newcommand{\tracelignes}[1]{
  \hfill\begin{tikzpicture}[x=\linewidth-0.8pt,y=0.2cm]
    \draw[color=couleurligne,line width=0.8pt] (0,4)--(1,4);
      \foreach \j in {1,...,#1}{
        \foreach \i in{1,2,3}{
          \draw[color=couleurinterligne,line width=0.5pt] (0,\i+4*\j)--(1,\i+4*\j);
        }
      \draw[color=couleurligne,line width=0.8pt] (0,4*\j+4)--(1,4*\j+4);
    }
  \end{tikzpicture}\hfill
}

\newcommand{\tracecarreaux}[1]{
  \hfill\begin{tikzpicture}
    \draw[xstep=0.5,ystep=0.5, color=couleurcarreau] (0,0) grid (\linewidth-0.8pt,#1);
  \end{tikzpicture}\hfill
}

\newcounter{compteursurligne}
\setcounter{compteursurligne}{1}

\newcommand{\tracesurligne}[1]{%
  \begin{tikzpicture}[overlay]
    \foreach \i in {1,2,...,#1} {%
    \ifnum\value{compteursurligne}=1
      \fill[couleursurlignelignea]($(0,0.85)+(0,-\i*\baselineskip)$) rectangle ($(0,0.85)+(\linewidth,-\i*\baselineskip-\baselineskip)$);
      \setcounter{compteursurligne}{0}
    \else
    \fill[couleursurligneligneb]($(0,0.85)+(0,-\i*\baselineskip)$) rectangle ($(0,0.85)+(\linewidth,-\i*\baselineskip-\baselineskip)$);
      \setcounter{compteursurligne}{1}
    \fi
    }%
\end{tikzpicture}%
}%

%Nouveau soulignement pour le titre, utilisant lua-ul
\newunderlinetype\beginUnderLine{\cleaders\hbox{%
  \setlength\unitlength{.1ex}%
  \begin{picture}(4,0)(0,1)
    \thicklines
    \put(0,-4){\line(1,0){4}}
    \put(0,-4.5){\line(1,0){4}}
  \end{picture}%
}}

\NewDocumentCommand\underLine{+m}{{\beginUnderLine#1}}

% Paramétrage tkz euclide

\tikzset{
  handdrawn/.style={%Nouveau style handdrawn pour les segments
    decorate,
    decoration={random steps,segment length=2mm,amplitude=0.3mm}
  },
  point style/.style = {%Style + par défaut pour les points seuls
    draw = black,
    inner sep = 3pt,
    shape = cross,
    minimum size = 3 pt,
    fill = black
	},
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% DÉFINITION DES COULEURS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{luacode}
  -- CouleursDocument() — Génère les commandes colorlet LaTeX à partir de la table
  --   COULEURS peuplée par CouleursUtilisateur().  Appelée à chaque
  --   appel de "parametrage" (les couleurs peuvent changer entre subfiles).
  function CouleursDocument()

    local PREMIER = PARAMETRES.premier

    -- Lignes, sections et arrière-plan
    tex.sprint(
      '\\colorlet{couleurligne}{'         .. FormatageString(COULEURS.ligne)         .. '}' ..
      '\\colorlet{couleurinterligne}{'     .. FormatageString(COULEURS.interligne)    .. '}' ..
      '\\colorlet{couleursection}{'        .. FormatageString(COULEURS.section)       .. '}' ..
      '\\colorlet{couleursubsection}{'     .. FormatageString(COULEURS.subsection)    .. '}' ..
      '\\colorlet{couleursubsubsection}{'  .. FormatageString(COULEURS.subsubsection) .. '}' ..
      '\\colorlet{couleurcarreau}{'        .. FormatageString(COULEURS.carreau)       .. '}' ..
      '\\colorlet{couleursurlignelignea}{' .. FormatageString(COULEURS.surlignelignea).. '}' ..
      '\\colorlet{couleursurligneligneb}{' .. FormatageString(COULEURS.surligneligneb).. '}' ..
      '\\colorlet{couleurboitecours}{'     .. FormatageString(COULEURS.boitecours)    .. '}' ..
      '\\colorlet{couleurbackground}{'     .. FormatageString(COULEURS.background)    .. '}'
    )

    -- Couleurs des environnements de cours et d'exercices
    tex.sprint(
      '\\colorlet{couleurapplication}{' .. FormatageString(COULEURS.application) .. '}' ..
      '\\colorlet{couleurdefinition}{'  .. FormatageString(COULEURS.definition)  .. '}' ..
      '\\colorlet{couleurconvention}{'  .. FormatageString(COULEURS.convention)  .. '}' ..
      '\\colorlet{couleurexercice}{'    .. FormatageString(COULEURS.exercice)    .. '}' ..
      '\\colorlet{couleurexemple}{'     .. FormatageString(COULEURS.exemple)     .. '}' ..
      '\\colorlet{couleurmethode}{'     .. FormatageString(COULEURS.methode)     .. '}' ..
      '\\colorlet{couleurpreuve}{'      .. FormatageString(COULEURS.preuve)      .. '}' ..
      '\\colorlet{couleurpropriete}{'   .. FormatageString(COULEURS.propriete)   .. '}' ..
      '\\colorlet{couleurremarque}{'    .. FormatageString(COULEURS.remarque)    .. '}' ..
      '\\colorlet{couleurenonce}{'      .. FormatageString(COULEURS.enonce)      .. '}' ..
      '\\colorlet{couleurcorrection}{'  .. FormatageString(COULEURS.correction)  .. '}'
    )

    -- Surlignage et couleurs sémantiques (rouge, bleu, vert)
    tex.sprint(
      '\\colorlet{couleursurligne}{'       .. FormatageString(COULEURS.surligne)       .. '}' ..
      '\\colorlet{couleursurlignevisible}{' .. FormatageString(COULEURS.surlignevisible).. '}' ..
      '\\colorlet{rouge}{'                 .. FormatageString(COULEURS.rouge)          .. '}' ..
      '\\colorlet{bleu}{'                  .. FormatageString(COULEURS.bleu)           .. '}' ..
      '\\colorlet{vert}{'                  .. FormatageString(COULEURS.vert)           .. '}'
    )

    tex.sprint('\\sethlcolor{couleursurligne}')
    tex.sprint('\\pagecolor{' .. COULEURS.background ..'}')

  end 
\end{luacode}

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FORMATAGES DIVERS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{luacode}
  -- PoliceDocument() — Applique la taille de police et les polices texte/maths
  --   à partir de POLICE et PARAMETRES.  La taille de police utilise
  --   KOMAoption{fontsize} pour fonctionner avec scrartcl.
  function PoliceDocument()
    local TAILLE = PARAMETRES.taille
    local FORMAT = PARAMETRES.format
    local PREMIER = PARAMETRES.premier

    if TAILLE == nil then
      if FORMAT == 'fiche' then
        tex.sprint('\\KOMAoption{fontsize}{'..  FormatageString(POLICE.taillefiche) ..'}')
      elseif FORMAT == 'diapo' then
        tex.sprint('\\KOMAoption{fontsize}{'..  FormatageString(POLICE.taillediapo) ..'}')
      end
    else
      tex.sprint('\\KOMAoption{fontsize}{' .. TAILLE ..'}')
    end

    if PREMIER then
      tex.sprint('\\renewcommand{\\important}[1]{'..  FormatageString(POLICE.important) ..'}')
      tex.sprint('\\renewcommand{\\arraystretch}{'..  FormatageString(POLICE.tableau) ..'}')
    end

  tex.sprint('\\IfFontExistsTF{' ..  FormatageString(POLICE.texte) ..'}{\\setmainfont{' ..  FormatageString(POLICE.texte) .. '}}\\par' ..
    '\\IfFontExistsTF{' ..  FormatageString(POLICE.math) .. '}{\\setmathfont{' ..  FormatageString(POLICE.math) .. '}}{}' ..
    '\\IfFontExistsTF{' ..  FormatageString(POLICE.mathcal) .. '}{\\setmathfont{' ..  FormatageString(POLICE.mathcal) .. '}[range=cal]}{}'
  )
  end
\end{luacode}

\newfontfamily\myfontScratch{FreeSans}%Pour les blocs Scratch de ProfCollege

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CRÉATION DES LOGOS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\logoactif}{}

\begin{luacode}
  -- LogosDocument() — Sélectionne l'icône (commande "logoactif") correspondant
  --   au type de document courant dans la table LOGOS.
  function LogosDocument()

    local TYPE = PARAMETRES.type

    if TYPE == 'activite' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.activite) ..'}')
    elseif TYPE == 'basique' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.basique) ..'}')
    elseif TYPE == 'bilan' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.bilan) ..'}')
    elseif TYPE == 'corrige' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.corrige) ..'}')
    elseif TYPE == 'cours' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.cours) ..'}')
    elseif TYPE == 'DM' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.DM) ..'}')
    elseif TYPE == 'DS' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.DS) ..'}')
    elseif TYPE == 'flash' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.flash) ..'}')
    elseif TYPE == 'interro' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.interro) ..'}')
    elseif TYPE == 'TD' then
      tex.sprint('\\renewcommand{\\logoactif}{' ..  FormatageString(LOGOS.TD) ..'}')
    end
  end
\end{luacode}

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CRÉATION DES TITRES %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\titre}[1]{}
\newcommand{\titreactif}[1]{}
\newcommand{\styleactif}[1]{}
\newcommand{\stylesections}[3]{}

\newcommand{\montitre}[2][\hspace{-0.25em}]{\renewcommand{\logoactif}{#1}\ifheader\ihead{\vspace*{-1em}\titre{#2}}\else\titre{#2}\fi}

\begin{luacode}
  -- StylesTitresDocument() — Définit les commandes "titre" et "styleactif" en
  --   fonction du type de document et de la présence d'un header.
  --   La commande "titre" génère l'espacement après le titre en mode sans-header.
  function StylesTitresDocument()

    local TYPE = PARAMETRES.type
    local HEADER = PARAMETRES.header

    if HEADER then
      tex.sprint('\\renewcommand{\\titre}[1]{'..  FormatageString(STYLESTITRES.titre) ..'}')
    else
      tex.sprint('\\renewcommand{\\titre}[1]{'..  FormatageString(STYLESTITRES.titre) .. '\\vspace{' ..  FormatageString(STYLESTITRES.espacement) ..'}}')
    end

    if TYPE == 'activite' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.activite) ..'}')
    elseif TYPE == 'basique' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.basique) ..'}')
    elseif TYPE == 'bilan' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.bilan) ..'}')
    elseif TYPE == 'corrige' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.corrige) ..'}')
    elseif TYPE == 'cours' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.cours) ..'}')
    elseif TYPE == 'DM' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.DM) ..'}')
    elseif TYPE == 'DS' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.DS) ..'}')
    elseif TYPE == 'flash' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.flash) ..'}')
    elseif TYPE == 'interro' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.interro) ..'}')
    elseif TYPE == 'TD' then
      tex.sprint('\\renewcommand{\\styleactif}[1]{' ..  FormatageString(STYLESTITRES.TD) ..'}')
    end
  end
\end{luacode}

\newcommand{\motcletitretoc}{}
\newif\iftitretoc

\begin{luacode}
  -- TitresDocument() — Fixe "motcletitretoc" (entrée TOC) et "titreactif"
  --   (titre affiché ou dans le header) pour le type de document courant.
  function TitresDocument()
    local TYPE = PARAMETRES.type
    local PREMIER = PARAMETRES.premier

    if TYPE == 'basique' then
      tex.sprint('\\titretocfalse')
    else
      tex.sprint('\\titretoctrue')
    end

    if TYPE == 'activite' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocactivite) ..'}')
    elseif TYPE == 'basique' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocbasique) ..'}')
    elseif TYPE == 'bilan' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocbilan) ..'}')
    elseif TYPE == 'corrige' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.toccorrige) ..'}')
    elseif TYPE == 'cours' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.toccours) ..'}')
    elseif TYPE == 'DM' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocDM) ..'}')
    elseif TYPE == 'DS' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocDS) ..'}')
    elseif TYPE == 'flash' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocflash) ..'}')
    elseif TYPE == 'interro' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocinterro) ..'}')
    elseif TYPE == 'TD' then
      tex.sprint('\\renewcommand{\\motcletitretoc}{' ..  FormatageString(TITRES.tocTD) ..'}')
    end

    tex.sprint('\\renewcommand{\\titreactif}{\\styleactif{' ..  FormatageString(TITRES.format) .. '}}')
 
  end
\end{luacode}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ENVIRONNEMENT ET COMMANDE VISIBLE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifmontre

\begin{luacode}

-- VerificationVisible(flag) — Compare flag à PARAMETRES.visible pour décider
--   si l'environnement "visible" doit afficher son contenu (montretrue/false).
--   flag est la valeur optionnelle de l'environnement (true par défaut).
function VerificationVisible(flag)
  local VISIBLE = PARAMETRES.visible
  local str = tostring(VISIBLE)
  local flg = tostring(flag)

  if VISIBLE == true then
    tex.sprint('\\visibletrue')
  else
    tex.sprint('\\visiblefalse')
  end

  if flg == str then
    tex.sprint('\\montretrue')
  else
    tex.sprint('\\montrefalse')
  end
end

\end{luacode}

\NewEnviron{visible}[1][true]{%
  \directlua{VerificationVisible(#1)}
  \ifmontre
    \BODY
  \fi
}

\newcommand{\visiblecmd}[2][true]{%
  \directlua{VerificationVisible(#1)}
  \ifmontre
    #2
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ENVIRONNEMENTS DE COURS ET EXERCICES %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\formatEnvCours}[2][]{}

\NewEnviron{application}[1][]{\BODY}
\NewEnviron{definition}[1][]{\BODY}
\NewEnviron{convention}[1][]{\BODY}
\NewEnviron{exemple}[1][]{\BODY}
\NewEnviron{methode}[1][]{\BODY}
\NewEnviron{preuve}[1][]{\BODY}
\NewEnviron{propriete}[1][]{\BODY}
\NewEnviron{remarque}[1][]{\BODY}

\NewEnviron{correction}[1][]{\BODY}
\NewEnviron{enonce}[1][]{\BODY}

\begin{luacode*}
  -- EnvironnementsDocument() — Redéfinit les environnements LaTeX
  --   (application, definition, propriete… enonce, correction) en injectant
  --   le code stocké dans ENVIRONNEMENTS.  Le bloc "PREMIER" concerne les
  --   boîtes de cours (communes à tous les types).  La logique enonce/correction
  --   diffère selon que le type est 'cours' ou un type exercices.
  function EnvironnementsDocument()

    local PREMIER = PARAMETRES.premier
    local TYPE = PARAMETRES.type

    if PREMIER then

      tex.sprint('\\renewcommand{\\formatEnvCours}[2][]{\\ifstretch\\vfill\\fi'..  FormatageString(ENVIRONNEMENTS.formatcours) ..'}')

      tex.sprint([[\RenewEnviron{application}[1][Application]{\formatEnvCours[#1]{couleurapplication}}]])
      tex.sprint([[\RenewEnviron{definition}[1][Définition]{\formatEnvCours[#1]{couleurdefinition}}]])
      tex.sprint([[\RenewEnviron{convention}[1][Convention]{\formatEnvCours[#1]{couleurconvention}}]])
      tex.sprint([[\RenewEnviron{exemple}[1][Exemple]{\formatEnvCours[#1]{couleurexemple}}]])
      tex.sprint([[\RenewEnviron{methode}[1][Méthode]{\formatEnvCours[#1]{couleurmethode}}]])
      tex.sprint([[\RenewEnviron{preuve}[1][Preuve]{\formatEnvCours[#1]{couleurpreuve}}]])
      tex.sprint([[\RenewEnviron{propriete}[1][Propriété]{\formatEnvCours[#1]{couleurpropriete}}]])
      tex.sprint([[\RenewEnviron{remarque}[1][Remarque]{\formatEnvCours[#1]{couleurremarque}}]])
    end

    if TYPE == 'cours' then

        tex.sprint([[\RenewEnviron{enonce}[1][Énoncé]{\formatEnvCours[#1]{couleurenonce}}]])

        tex.sprint([[\RenewEnviron{correction}[1][Correction]{\formatEnvCours[#1]{couleurcorrection}}]])

      else

        -- Environnement enonce pour les types exercices
        -- (TD, DM, DS, interro, activite, bilan…)
        local tocexo    = FormatageString(ENVIRONNEMENTS.tocexercice)
        local tocenonce = FormatageString(ENVIRONNEMENTS.tocenonce)
        local fmtenonce = FormatageString(ENVIRONNEMENTS.enonce)
        tex.sprint(
          '\\RenewEnviron{enonce}[1][\\thecompteurexercice]{' ..
            '\\stepcounter{compteurexercice}' ..
            '\\phantomsection\\addcontentsline{toc}{subsection}{' .. tocexo .. '~\\thecompteurexercice}' ..
            '\\ifenonce' ..
              '\\phantomsection\\addcontentsline{toc}{subsubsection}{' .. tocenonce .. '}' ..
              '\\ifstretch\\vfill\\fi' ..
              fmtenonce ..
            '\\fi' ..
            '\\bareme{}\\competence{}\\difficulte{}\\source{}\\theme{}' ..
          '}'
        )

        -- Environnement correction pour les types exercices
        local toccorr = FormatageString(ENVIRONNEMENTS.toccorrection)
        local fmtcorr = FormatageString(ENVIRONNEMENTS.correction)
        tex.sprint(
          '\\RenewEnviron{correction}[1][]{' ..
            '\\ifcorrection' ..
              '\\phantomsection\\addcontentsline{toc}{subsubsection}{' .. toccorr .. '}' ..
              '\\ifstretch\\vfill\\fi' ..
              fmtcorr ..
            '\\fi' ..
          '}'
        )

      end
  end
\end{luacode*}

\begin{luacode*}

  -- TitreLua() — Déclenche l'affichage du titre actif (\titreactif) et
  --   l'ajout de l'entrée dans la TOC.  En mode PREMIER (premier appel),
  --   le titre est différé à \AtBeginDocument pour que toutes les polices
  --   soient chargées.  Met PARAMETRES.premier à false en fin d'exécution.
  function TitreLua()
    local HEADER = PARAMETRES.header
    local PREMIER = PARAMETRES.premier
    local TYPE = PARAMETRES.type

    if PREMIER then

      if not HEADER then
        tex.sprint('\\AtBeginDocument{\\titreactif}')

        if TYPE ~= 'basique' then
          tex.sprint('\\phantomsection\\addcontentsline{toc}{section}{\\motcletitretoc}')
        end

      end

    else

      if not HEADER then
        tex.sprint('\\titreactif')
      end
    tex.sprint('\\phantomsection\\addcontentsline{toc}{section}{\\motcletitretoc}')

    end

    PARAMETRES.premier = false
  end 
\end{luacode*}

\begin{luacode*}
  function mesParametres(str)
  end
\end{luacode*}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% COMMANDE PARAMETRAGE PERMETTANT DE MODIFIER LES OPTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{luacode*}
  -- ParametrageDocument() — Point d'entrée central appelé par \parametrage{}.
  --   Lit les variables globales Lua (Type, Format, Niveau…) définies par
  --   l'utilisateur, les transfère dans PARAMETRES, puis orchestre dans
  --   l'ordre toutes les fonctions de configuration.
  --   En fin de fonction, les variables globales sont remises à nil pour
  --   éviter toute pollution entre deux appels de \parametrage{}.
  function ParametrageDocument()

    -- Raccourci local : retourne val si non-nil, sinon la valeur par défaut def.
    -- Évite le pattern répétitif "if X == nil then ... else ... end".
    local function defaut(val, def)
      if val == nil then return def else return val end
    end

    -- Format du document
    PARAMETRES.format = (Format == 'diapo') and 'diapo' or 'fiche'

    -- Informations pédagogiques (chaînes vides si non fournies)
    PARAMETRES.chapitre = defaut(Chapitre, '')
    PARAMETRES.numero   = defaut(Numero,   '')
    PARAMETRES.niveau   = defaut(Niveau,   '')
    PARAMETRES.compteur = defaut(Compteur, '1')
    PARAMETRES.type     = defaut(Type,     'basique')

    -- Options de rendu
    PARAMETRES.print  = defaut(Impression, false)
    PARAMETRES.header = defaut(Header,     false)
    PARAMETRES.taille = Taille  -- nil = taille automatique selon le format

    -- Options d'affichage du contenu
    PARAMETRES.correction = defaut(Correction, false)
    PARAMETRES.enonce     = defaut(Enonce,     false)
    PARAMETRES.visible    = defaut(Visible,    false)

    -- Options des exercices (métadonnées affichées dans l'énoncé)
    PARAMETRES.bareme     = defaut(Bareme,     false)
    PARAMETRES.competence = defaut(Competence, false)
    PARAMETRES.difficulte = defaut(Difficulte, false)
    PARAMETRES.source     = defaut(Source,     false)
    PARAMETRES.theme      = defaut(Theme,      false)
    PARAMETRES.stretch    = defaut(Stretch,    false)

    -- Configuration dans l'ordre imposé (ne pas modifier l'ordre)
    PoliceUtilisateur()    -- peuple POLICE
    PoliceDocument()       -- applique la police

    FormatUtilisateur()    -- peuple PAGE
    FormatDocument()       -- applique la mise en page

    CouleursUtilisateur()  -- peuple COULEURS
    CouleursDocument()     -- applique les couleurs

    LogosUtilisateur()     -- peuple LOGOS
    LogosDocument()        -- sélectionne \logoactif

    BooleensDocument()     -- synchronise les \if... LaTeX

    StylesTitresUtilisateur() -- peuple STYLESTITRES
    StylesTitresDocument()    -- définit \titre et \styleactif
    TitresUtilisateur()       -- peuple TITRES
    TitresDocument()          -- définit \motcletitretoc et \titreactif
    EnvironnementsUtilisateur() -- peuple ENVIRONNEMENTS
    EnvironnementsDocument()    -- redéfinit les environnements LaTeX
    TitreLua()                  -- émet le titre (ou le diffère à \AtBeginDocument)

    -- Réinitialisation des variables globales Lua (évite la pollution entre appels)
    Type = nil; Format = nil; Chapitre = nil; Numero = nil
    Niveau = nil; Compteur = nil; Taille = nil
    Impression = nil; Header = nil
    Correction = nil; Enonce = nil; Visible = nil
    Bareme = nil; Competence = nil; Difficulte = nil
    Source = nil; Theme = nil; Stretch = nil
  end
\end{luacode*}

\newcommand{\parametrage}{\ifsubfile\else\directlua{ParametrageDocument()}\setcounter{compteurexercice}{0}\fi\ifpremier\premierfalse\mygeometry\fi}

\AtEndPreamble{\ifpremier\parametrage\fi}