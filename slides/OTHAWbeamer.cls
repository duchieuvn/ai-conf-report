% Vorlage für LaTeX-Beamer nach dem Corporate Design der OTH Amberg-Weiden
% Autoren: Andreas Aßmuth, Matthias Söllner, Daniel Loebenberger
% Aktuelle Version: v0.04
% Stand: 27.03.2023
%
% Changelog:
%
% v0.04: Neues Corporate Design umgesetzt (27.03.2023)
% v0.03: Überarbeitung Titelfolie, Ausrichtung Information Fußzeile,
%        Positionierung Logos, Optionen lecture, tochead (09.01.2019)
% v0.02: Anpassung der Vorlage (14.08.2015)
% + Ermöglichung der Option "aspectratio=169" für Präsentationen mit Bildformat 16:9
%
% v0.01: Erstellung der Klassendatei (20.11.2013)
%

\ProvidesClass{OTHAWbeamer}[2023/03/27 v0.04 Vorlage Ostbayerische Technische Hochschule Amberg-Weiden]
%
\PassOptionsToPackage{english,greek,ngerman}{babel}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}

\newif\if@lecture
\@lecturefalse

\newif\if@tochead
\@tocheadfalse

\newif\if@showerlaeuterung
\@showerlaeuterungfalse

\newif\if@notes
\@notesfalse

\newif\if@amberg
\@ambergfalse

\newif\if@weiden
\@ambergfalse

\newif\if@amwen
\@amwentrue


\DeclareOption{tochead}{%
    \@tocheadtrue
}

\DeclareOption{lecture}{%
    \@lecturetrue
}

\DeclareOption{notochead}{
  \@tocheadfalse
}

\DeclareOption{annotate}{
  \@showerlaeuterungtrue
}

\DeclareOption{notes}{
  \PassOptionsToClass{handout}{beamer}
  \@notestrue
}

\DeclareOption{amberg}{
  \@ambergtrue
  \@weidenfalse
  \@amwenfalse
}

\DeclareOption{weiden}{
  \@ambergfalse
  \@weidentrue
  \@amwenfalse
}

\DeclareOption{amwen}{
  \@ambergfalse
  \@weidenfalse
  \@amwentrue
}

\ProcessOptions\relax

\LoadClass[xcolor=table, covered, hyperref={bookmarks}]{beamer}

\if@notes
\RequirePackage{pgfpages}
\RequirePackage{handoutWithNotes}
\fi

\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage{babel}
\RequirePackage{graphicx}

\RequirePackage{tikz}
\RequirePackage{hyperref}

\RequirePackage{version}

\RequirePackage{adjustbox}
\RequirePackage{etoolbox}


\newcommand*{\email}[1]{\def\insertemail{#1}}
\email{}

% Define \place{} command, defaulting to Kirchheim.
\newcommand*{\place}[1]{\def\insertplace{#1}}
\place{Amberg}


% Farbdefinitionen
\definecolor{schwarz}{RGB}{0,0,0}
\definecolor{weiss}{RGB}{255,255,255}

\definecolor{orange1}{RGB}{242,148,0}
\definecolor{orange2}{RGB}{248,187,107}
\definecolor{orange3}{RGB}{251,214,166}
\definecolor{orange4}{RGB}{254,240,222}

\definecolor{grau1}{RGB}{176,167,157}
\definecolor{grau2}{RGB}{203,196,190}
\definecolor{grau3}{RGB}{223,218,214}
\definecolor{grau4}{RGB}{243,241,239}

\definecolor{blau1}{RGB}{127,169,182}
\definecolor{blau2}{RGB}{171,198,207}
\definecolor{blau3}{RGB}{208,220,224}
\definecolor{blau4}{RGB}{238,242,243}

\definecolor{rot1}{RGB}{162,72,133}
\definecolor{rot2}{RGB}{192,137,174}
\definecolor{rot3}{RGB}{215,184,207}
\definecolor{rot4}{RGB}{240,229,237}

\definecolor{gruen1}{RGB}{120, 162, 110}
\definecolor{gruen2}{RGB}{172, 194, 160}
\definecolor{gruen3}{RGB}{205, 217, 196}
\definecolor{gruen4}{RGB}{237, 240, 233}

% Rand setzen
\newlength{\beamerleftmargin}
\newlength{\beamerrightmargin}
\newlength{\beamertopmargin}
\newlength{\beamerbotmargin}
\setlength{\beamerleftmargin}{.5cm}
\setlength{\beamerrightmargin}{\beamerleftmargin}
\setlength{\beamertopmargin}{.3cm}
\setlength{\beamerbotmargin}{.3cm}

\setbeamersize{text margin left=\beamerleftmargin}
\setbeamersize{text margin right=\beamerrightmargin}
\setbeamersize{sidebar width left=0cm}
\setbeamersize{sidebar width right=0cm}

\newlength{\othruleheadlinetop}
\newlength{\othruleheadlinebot}
\newlength{\othrulefootline}
\setlength{\othruleheadlinetop}{.4mm}
\setlength{\othruleheadlinebot}{.4mm}
\setlength{\othrulefootline}{.1mm}


% Festlegung, welche Elemente in welchen Farben dargestellt werden sollen
\setbeamercolor*{title}{fg=weiss, bg=weiss}
\setbeamercolor*{frametitle}{fg=schwarz, bg=weiss}
\setbeamercolor*{normal text}{fg=schwarz, bg=weiss}
\setbeamercolor*{alerted text}{fg=orange1, bg=weiss}
\setbeamercolor*{gray text}{fg=grau1, bg=weiss}
\setbeamercolor*{footline}{fg=weiss, bg=grau1}
\setbeamercolor*{structure}{fg=orange1}
\setbeamercolor*{example text}{fg=gruen1, bg=weiss}
\setbeamertemplate{blocks}[rounded][shadow=true]
\setbeamercolor*{block title}{use=structure, fg=weiss, bg=orange1}
\setbeamercolor*{block title alerted}{use=alerted text, fg=weiss, bg=rot1}
\setbeamercolor*{block title example}{use=example text, fg=weiss, bg=gruen1}
\setbeamercolor*{block body}{parent=normal text, use=block title, bg=orange4}
\setbeamercolor*{block body alerted}{parent=normal text, use=block title, bg=rot4}
\setbeamercolor*{block body example}{parent=normal text, use=block title, bg=gruen4}
\setbeamercolor*{button}{fg=weiss, bg=orange1}
\setbeamercolor{bibliography entry author}{fg=,bg=}
\setbeamercolor{bibliography entry title}{fg=,bg=}
\setbeamercolor{bibliography entry location}{fg=,bg=}
\setbeamercolor{bibliography entry note}{fg=,bg=}

% Festlegung der Schriftarten
\setbeamerfont{tiny structure}{series=\mdseries, size=\tiny}
\setbeamerfont{title}{series=\bfseries, size=\Large}
\setbeamerfont{subtitle}{series=\mdseries, size=\large}
\setbeamerfont*{author}{series=\mdseries, size=\normalsize}
\setbeamerfont{frametitle}{series=\bfseries, size=\large}
\setbeamerfont{framesubtitle}{series=\mdseries, size=\normalsize}
\setbeamerfont*{footline}{series=\mdseries, size=\tiny}
\setbeamerfont*{date}{series=\mdseries, size=\footnotesize}
\setbeamerfont{block title}{series=\bfseries, size=\normalsize}

% Standardeinstellungen
\setbeamertemplate{itemize item}[circle]
\setbeamertemplate{section/subsections in toc}[ball]{}
\setbeamercolor{section in toc}{fg=schwarz, bg=weiss}
\setbeamercolor{subsection in toc}{fg=schwarz, bg=weiss}
\setbeamertemplate{headline}{}
\setbeamertemplate{navigation symbols}{}
\def\beamer@andinst{\quad}

\setlength\textwidth{\paperwidth}
\addtolength\textwidth{-30pt}

\newlength{\logowidth}
\setlength\logowidth{\paperwidth}
\addtolength\logowidth{-4.53cm}

\newlength{\titlewidth}
\setlength\titlewidth{\paperwidth}
\addtolength\titlewidth{-3.7cm}

\pgfdeclareimage[width=2.5cm]{folie-logo}{logos/logo-oth-aw-text-seite.png}

\defbeamertemplate*{title page}{OTHAW}{%
%  \begin{tikzpicture}[remember picture,overlay]
%  \node[anchor=north east, inner sep=0,outer sep=0, xshift=-.5cm, yshift=-.3cm]   at (current page.north east){%
%  \pgfuseimage{titel-logo}};
%\end{tikzpicture}

    \begin{tikzpicture}[remember picture,overlay]
      \node[above right,inner sep=0pt,outer sep=0pt] at (current page.south west) {
      \if@amberg
        \includegraphics[width=\paperwidth, height=\paperheight]{images/amberg-titel.png}
      \else
      \if@weiden
        \includegraphics[width=\paperwidth, height=\paperheight]{images/weiden-titel.png}
      \else
      \if@amwen
        \includegraphics[width=\paperwidth, height=\paperheight]{images/amwen-titel.png}
      \fi
      \fi
      \fi
      };
    \end{tikzpicture}

  \vskip6.55cm
  \usebeamercolor[fg]{title}
  {\usebeamerfont{title}\inserttitle}
  \ifx\insertsubtitle\@empty\else\vskip0.1em%
    {\usebeamerfont{subtitle}\insertsubtitle}%
  \fi
  %\vskip-.6cm%
  %\color{orange2}\rule{0.5cm}{\othruleheadlinetop}%
  \vskip.2cm%
  \begin{beamercolorbox}[sep=0pt]{author}%
    \usebeamerfont{institute}%
    %\insertdate\\[.1cm]
    \insertauthor\ | \insertplace
    %\ifx\insertinstitute\empty\else{\\\usebeamerfont{institute}\insertinstitute}\fi
    %\ifx\insertemail\empty\else{\\\usebeamerfont{institute}\href{mailto:\insertemail}{\usebeamerfont{institute}\texttt{<\insertemail>}}}\fi
    %\\[2em]
    %\mbox{}{\insertplace, \insertdate}\\[1em]
    %\mbox{}{\inserttitlegraphic}

  \end{beamercolorbox}
}

\defbeamertemplate*{footline}{OTHAW}{%
  \ifnum\value{framenumber}=1% check if it's the title frame
  % do nothing
  \else%
    \hskip\beamerleftmargin%
    \fcolorbox{white}{white}{
    \begin{adjustbox}{minipage=\dimexpr\textwidth-\beamerrightmargin-\beamerleftmargin, margin=0pt 0pt}
        \color{grau1}\rule{\dimexpr\textwidth-\beamerrightmargin}{\othrulefootline}%\par%
        \vskip.1cm%
        \parbox{\dimexpr\textwidth-\beamerrightmargin}{%
            \color{grau1}\usebeamerfont{footline}\inserttitle\if@lecture: \insertsubtitle\fi\  | \insertauthor \hfill \insertdate \hspace{0.7cm} \insertframenumber\\[-.15cm]
        }
    \end{adjustbox}}%
  \fi
}

%\defbeamertemplate*{footline}{title slide}{%
%}


\defbeamertemplate*{headline}{OTHAW}
{%
\begin{tikzpicture}[remember picture,overlay]
\node[anchor=north east, inner sep=0,outer sep=0, xshift=-\beamerrightmargin, yshift=-\beamertopmargin]   at (current page.north east){%
\pgfuseimage{folie-logo}};
\end{tikzpicture}
}

\defbeamertemplate*{frametitle}{OTHAW}{%
  \vskip\beamertopmargin
  \if@tochead%
  \vbox{%
    \tinyline{\hspace{.2cm}\insertsection\hfill}%
    \setbox\beamer@tempbox=\hbox{\insertsubsection}%
    \tinyline{\ifdim\wd\beamer@tempbox>1pt{\hspace{.2cm}\hskip2pt\raise1.9pt\hbox
         {\vrule width0.4pt height1.875ex\vrule width 5pt height0.4pt}}
         \hskip1pt\insertsubsection\fi\hfill}%
  }
  \vskip.3cm
  \fi
  %
  \ifx\insertframesubtitle\empty%
    \ifstrempty{\insertframetitle}{%
    % Draw noting
    }{
    \parbox[b][0.3cm]{\titlewidth}{%
      \usebeamerfont*{frametitle}\usebeamercolor{frametitle}\insertframetitle
      \mbox{}\\[-.25cm]
      \color{orange1}\rule{0.5cm}{\othruleheadlinetop}%
    }
  }
  \else
  \parbox[b][0.8cm]{\titlewidth}{%
    \usebeamerfont*{frametitle}\usebeamercolor{frametitle}\insertframetitle
    \newline\usebeamerfont*{framesubtitle}\insertframesubtitle%
  }
  \mbox{}\\[-.25cm]
  \color{orange1}\rule{0.5cm}{\othruleheadlinetop}%
  \fi
}

\setbeamertemplate{footline}[title slide]

\def\maketitle{%
  \ifbeamer@inframe\titlepage\else\frame{\titlepage}\fi%
  \setbeamertemplate{frametitle}[OTHAW]%
  \setbeamertemplate{footline}[OTHAW]
}

\newenvironment{erlaeuterung}{%
\addtocounter{framenumber}{-1}
\begin{frame}
\frametitle{Erläuterungen}
}{ \end{frame}}

\if@showerlaeuterung \else \excludeversion{erlaeuterung}\fi
