#!/bin/bash

# Supprimer l'ancien zip s'il existe
if [ -f "multiplicator.zip" ]; then
    rm multiplicator.zip
fi

# Créer le nouveau zip
cd lambdas/multiplicator
zip -r ../../multiplicator.zip .
cd ../..

echo "Le fichier multiplicator.zip a été créé avec succès à la racine du projet." 