//
//  PokemonDetailViewController.swift
//  PokedexSprint_iOS17
//
//  Created by Stephanie Ballard on 5/8/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonIdTextLabel: UILabel!
    @IBOutlet weak var pokemonTypesTextLabel: UILabel!
    @IBOutlet weak var pokemonAbiltiesTextLabel: UILabel!
    
    // MARK: - Properties -
    var pokemonApiController: PokemonApiController?
    var pokemon: Pokemon?
    
    
    // MARK: - Lifecycle Functions -
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        pokemonSearchBar.becomeFirstResponder()
        
    }
    
    // MARK: - Actions -
    @IBAction func savePokemonButtonTapped(_ sender: UIButton) {
        guard let pokemon = pokemon else { return }
        pokemonApiController?.savePokemon(pokemon: pokemon)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Helper Methods -
    func updateViews() {
        if let pokemon = pokemon {
            pokemonNameLabel.text = pokemon.name
            var abiltitiesText = ""
            for ability in pokemon.abilities {
                abiltitiesText += "\(ability.ability.name)"
            }
            pokemonAbiltiesTextLabel.text = abiltitiesText
            
            var typesText = ""
            for type in pokemon.types {
                typesText += "\(type.type.name)"
            }
            pokemonTypesTextLabel.text = typesText
            
            pokemonIdTextLabel.text = "\(pokemon.id)"
            
            do {
                guard let url = URL(string: pokemon.sprites.frontDefault) else { return }
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                pokemonImageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
}
extension PokemonDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        pokemonApiController?.getPokemon(searchTerm: searchBarText) { result in
            switch result {
            case .success(let pokemon):
                print(pokemon)
                self.pokemon = pokemon
                DispatchQueue.main.async {
                    self.updateViews()
                }
            case .failure(let error):
                print("Error fetching pokemon: \(error)")
            }
        }
    }
}
