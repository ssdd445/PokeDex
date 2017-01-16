import UIKit
import AVFoundation

class ViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UISearchBarDelegate
{
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicPlayer:AVAudioPlayer!
    var pokemon = [Pokemon]()
    var filteredPoken = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        parsePokemonCSV()
        //initAudio()
    }
    
    func parsePokemonCSV()
    {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do
        {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            print(rows)
            
            for row in rows
            {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokie = Pokemon(name: name, pokeDexID: pokeId)
                pokemon.append(pokie)
            }
        }
        catch
        {
            print(error)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PokeCell
        {
            
            let poke:Pokemon!
            
            if inSearchMode
            {
                poke = filteredPoken[indexPath.row]
                cell.configureCell(poke)
            }
            else
            {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var pokie: Pokemon!
        
        if inSearchMode
        {
            pokie = filteredPoken[indexPath.row]
        }
        else
        {
            pokie = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "detailed", sender: pokie)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if inSearchMode
        {
            return filteredPoken.count
        }
        return pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 104, height: 104)
    }
    
    func initAudio()
    {
        let url = Bundle.main.path(forResource: "hello", ofType: "mp3")
        
        do
        {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: url!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            musicPlayer.volume = 0.1
        }
        catch
        {
            print(error)
        }
    }
    
    @IBAction func musicButtonRest(_ sender: Any)
    {
        if musicPlayer.isPlaying
        {
            musicPlayer.pause()
        }
        else
        {
            musicPlayer.play()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text == nil || searchBar.text == ""
        {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        }
        else
        {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            filteredPoken = pokemon.filter({$0.name.range(of: lower) != nil})
            collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "detailed")
        {
            if let detailedVC = segue.destination as? DetailedPokemon
            {
                if let pokie = sender as? Pokemon
                {
                    detailedVC.pokemon = pokie
                }
            }
        }
    }
}
