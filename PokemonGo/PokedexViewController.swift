//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by alex on 4/26/17.
//  Copyright © 2017 Alexander Cayetano Yaya. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.caughtPokemons = getAllCaughtPokemons()
        self.uncaughtPokemons = getAllUncaughtPokemons()

        
        print("CAPTURADAOS \(self.caughtPokemons.count)")
        print("NO CAPTURADAOS \(self.uncaughtPokemons.count)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else{
            return "No Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.caughtPokemons.count
        }else{
            return self.uncaughtPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonTableViewCell
       
        var pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.caughtPokemons[indexPath.row]
            cell.pokemonTimesCaughtLabel.text = "Veces capturado: \(pokemon.timesCaught)"
        }else{
            pokemon = self.uncaughtPokemons[indexPath.row]
            cell.pokemonTimesCaughtLabel.text = ""
        }
        
        //cell.textLabel?.text = pokemon.name
        //cell.imageView?.image = UIImage(named: pokemon.imageFileName!)
        
        cell.pokemonNameLabel?.text = pokemon.name
        cell.pokemonImageView?.image = UIImage(named: pokemon.imageFileName!)
        
        return cell
    }
    
    
    
    
    @IBAction func backToMapPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
