import UIKit

class PokeCell: UICollectionViewCell
{
    @IBOutlet weak var pokeImage:UIImageView!
    @IBOutlet weak var pokeLabel:UILabel!
    
    var pokemon:Pokemon!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon)
    {
        self.pokemon = pokemon
        pokeLabel.text = self.pokemon.name.capitalized
        pokeImage.image = UIImage(named: "\(self.pokemon.pokedexID)")
    }
}
