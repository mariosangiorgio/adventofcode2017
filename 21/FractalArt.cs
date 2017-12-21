using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;

public sealed class Image{
  private bool[][] _bits;
  public int Size => _bits.Count();

  public Image(bool[][] bits){
    _bits = bits;
  }

  public int PixelsOn(){
    return _bits.Select(row => row.Count(bit => bit)).Sum();
  }


  public override string ToString(){
    return string.Join("\n", _bits.Select(line => string.Join("", line.Select(bit => bit ? "#" : "."))));
  }

  public Image[] Explode(){
    var n = _bits.Count();
    var linearized = _bits.SelectMany(x => x).ToList();
    if(n % 2 == 0){
      var subImages = new List<Image>();
      for(var i = 0; i < n / 2; ++i){
        for(var j = 0; j < n / 2; ++j){
          var offset = 2*i + 2*n*j;
          subImages.Add(
            new Image(
            new []{
              new []{linearized[offset + 0], linearized[offset + 1]},
              new []{linearized[offset + n], linearized[offset + n + 1]}
              }));
        }
      }
      return subImages.ToArray();
    }
    if(n % 3 == 0){
      var subImages = new List<Image>();
      for(var i = 0; i < n / 3; ++i){
        for(var j = 0; j < n / 3; ++j){
          var offset = 3*i + 3*n*j;
          subImages.Add(
            new Image(
            new []{
              new []{linearized[offset + 0], linearized[offset + 1], linearized[offset + 2]},
              new []{linearized[offset + n], linearized[offset + n + 1], linearized[offset + n + 2]},
              new []{linearized[offset + 2*n], linearized[offset + 2*n + 1], linearized[offset + 2*n + 2]}
              }));
        }
      }
      return subImages.ToArray();
    }
    throw new Exception();
  }

  private bool Matches(Image  other){
    if(_bits.Count() != other._bits.Count()){
      return false;
    }
    for(var i = 0; i < _bits.Count(); ++i){
      for(var j = 0; j < _bits.Count(); ++j){
        if(_bits[i][j] != other._bits[i][j]){
          return false;
        }
      }
    }
    return true;
  }

  private Image Flipped(){
    var n = _bits.Count();
    var bits = new bool[n][];
    for(var i = 0; i < n; ++i){
      bits[i] = new bool[n];
      for(var j = 0; j < n; ++j){
        bits[i][j] = _bits[i][n-j-1];
      }
    }
    return new Image(bits);
  }

  private Image Rotated(){
    var n = _bits.Count();
    var bits = new bool[n][];
    for(var i = 0; i < n; ++i){
      bits[i] = new bool[n];
      for(var j = 0; j < n; ++j){
        bits[i][j] = _bits[n-j-1][i];
      }
    }
    return new Image(bits);
  }

  private List<Image> Compatible(){
    var images = new List<Image>();
    images.Add(this);
    images.Add(this.Rotated());
    images.Add(this.Rotated().Rotated());
    images.Add(this.Rotated().Rotated().Rotated());
    images.Add(this.Flipped());
    images.Add(this.Flipped().Rotated());
    images.Add(this.Flipped().Rotated().Rotated());
    images.Add(this.Flipped().Rotated().Rotated().Rotated());
    return images;
  }

  public Image Transform(List<Pattern> patterns){
    var matched = patterns.First(pattern => pattern.From.Compatible().Any(Matches));
    return matched.To;
  }

  public static Image Compact(List<Image> subImages){
    // Subimages have the same size
    var lines = (int)Math.Sqrt(subImages.Count());
    var subImageSize = subImages[0].Size;
    var size = lines * subImageSize;
    var bits = new bool[size][];
    for(var i = 0; i < size; ++i){
      bits[i] = new bool[size];
    }
    for(var i = 0; i < lines; ++i){
      for(var j = 0; j < lines; ++j){
        var subImage = subImages[i + lines*j];
        for(var k = 0; k < subImage.Size; ++k){
          for(var l = 0; l < subImage.Size; ++l){
            bits[subImageSize*i+k][subImageSize*j+l] = subImage._bits[k][l];
          }
        }
      }
    }
    return new Image(bits);
  }
}

public sealed class Pattern{
  public Image From {get;}
  public Image To {get;}

  public Pattern(Image from, Image to){
    From = from;
    To = to;
  }
}

public static class FractalArt{
  private static Image ParseImage(string input){
    return new Image(
      input
        .Split('/')
        .Select(row => row.Select(c => c == '#').ToArray())
        .ToArray()
      );
  }

  private static Pattern ParsePattern(string input){
     var tokens = input.Split(new []{" => "}, StringSplitOptions.RemoveEmptyEntries);
     return new Pattern(ParseImage(tokens[0]), ParseImage(tokens[1]));
  }

  public static void Main(string[] args){
    var image = ParseImage( ".#./..#/###");
    var patterns =
      File.ReadAllLines("/Users/mariosangiorgio/Downloads/input")
      .Select(ParsePattern)
      .ToList();
    for(var i = 0; i < 18; ++i){
      image =
        Image.Compact(
          image.Explode()
          .Select(x => x.Transform(patterns))
          .ToList()
        );
      if(i==4){
        Console.WriteLine($"Part 1: {image.PixelsOn()}");
      }
    }
    Console.WriteLine($"Part 2: {image.PixelsOn()}");
  }
}