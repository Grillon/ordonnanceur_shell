A propos
========
Ceci est un simple ordonnanceur shell. Il permet de lancer des taches en parallele sur plusieurs serveur.
Cette premiere version est une ebauche locale.

Description de l'ebauche
========================
Elle est composé :

* d'un ordonnanceur
chargé de lancer les taches
* d'un surveillant
chargé de killer les taches depassant le timeout
* d'un executant
chargé de lancer l'execution
* d'une fonction de test 
chargée de lancer des taches avec des temps d'execution differents

Il y a aussi des variables definissant le timeout, le nombre de tache max en simultané, le nom des serveurs cibles.

A venir
=======
A terme cela deviendra un element important d'un outil de deploiement que je suis en train de developper.

A venir dans l'immediat
=======================
* gestion de groupes
afin de pouvoir lancer un ordonnanceur dans un ordonnanceur
il faut que le groupe puisse se definir automatiquement, j'ai l'idée d'ajouter un p comme prime au groupe choisi.
ex : groupe1 lance un ordonnanceur groupe1 il s'appellera groupe1p
s'il n'a pas de nom ce sera p
si p existe déjà ce sera pp etc...
* amelioration de l'atomicité des taches. Il y a qq confusions au niveau des roles à mon sens.
* ajout de la gestion de CSV en entréé et en sortie

J'hésite sur qq points
======================
* redeveloppement en perl???
* mix perl/shell?
* double developpement 1 version shell et une en perl?

licence
=======
one line to give the program's name and an idea of what it does.
Copyright (C) 2014-2015  Thierry VOGEL alias Thierry Grillon

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

