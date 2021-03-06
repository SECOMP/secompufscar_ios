//
//  AtividadeAux.swift
//  SECOMP
//
//  Created by Marcelo de Oliveira da Silva on 8/17/16.
//  Copyright © 2016 secompufscar. All rights reserved.
//

import Foundation
import UIKit

class AtividadeAux {
    var nome_atividade: String
    var descricao_atividade: String
    var data_inicio_atividade: String
    var hora_inicio_atividade: String
    var hora_fim_atividade: String
    var hora_retorno_atividade: String?
    var hora_fim_retorno_atividade: String?
    var local_atividade: String
    var ministrante_atividade: String
    var foto_atividade: String
    var tipo_atividade: String?
    var imagem_atividade: UIImage?
    
    init(
        nome_atividade: String,
        descricao_atividade: String,
        data_inicio_atividade: String,
        hora_inicio_atividade: String,
        hora_fim_atividade: String,
        hora_retorno_atividade: String?,
        hora_fim_retorno_atividade: String?,
        local_atividade: String,
        ministrante_atividade: String,
        foto_atividade: String) {
        self.nome_atividade = nome_atividade
        self.descricao_atividade = descricao_atividade
        self.data_inicio_atividade = data_inicio_atividade
        self.hora_inicio_atividade = hora_inicio_atividade
        self.hora_fim_atividade = hora_fim_atividade
        self.hora_retorno_atividade = hora_retorno_atividade
        self.hora_fim_retorno_atividade = hora_fim_retorno_atividade
        self.local_atividade = local_atividade
        self.ministrante_atividade = ministrante_atividade
        self.foto_atividade = foto_atividade
    }
}

class DataFromSite {
    
    static var atividades = [AtividadeAux]()
    
    static func load() -> Bool {
        let requestURL = NSURL(string: "https://secompufscar.com.br/2016/app/")!
        let urlRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Download concluído")
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    print(json)
                    print(json as? [[Dictionary<String, String>]])

                    self.atividades = []
                    
                    if let palestras = json["palestras"] as? [[String: String]] {
                        
                        for palestra in palestras {
                            
                           let aux = AtividadeAux(nome_atividade: palestra["nome_atividade"]!, descricao_atividade: palestra["descricao_atividade"]!, data_inicio_atividade: palestra["data_inicio_atividade"]!, hora_inicio_atividade: palestra["hora_inicio_atividade"]!, hora_fim_atividade: palestra["hora_fim_atividade"]!, hora_retorno_atividade: nil, hora_fim_retorno_atividade: nil, local_atividade: palestra["local_atividade"]!, ministrante_atividade: palestra["ministrante_atividade"]!, foto_atividade: palestra["foto_atividade"]!)
                            
                            aux.tipo_atividade = "palestra"
                            
                            let imageUrl = NSURL(string: aux.foto_atividade)
                            let data = NSData(contentsOfURL: imageUrl!)
                            aux.imagem_atividade = UIImage(data: data!)
                            
                            self.atividades.append(aux)
                        }
                        
                        
                        if let minicursos = json["minicursos"] as? [[String: String]] {
                            for minicurso in minicursos {
                                
                                let aux = AtividadeAux(nome_atividade: minicurso["nome_atividade"]!, descricao_atividade: minicurso["descricao_atividade"]!, data_inicio_atividade: minicurso["data_inicio_atividade"]!, hora_inicio_atividade: minicurso["hora_inicio_atividade"]!, hora_fim_atividade: minicurso["hora_fim_atividade"]!, hora_retorno_atividade: nil, hora_fim_retorno_atividade: nil, local_atividade: minicurso["local_atividade"]!, ministrante_atividade: minicurso["ministrante_atividade"]!, foto_atividade: minicurso["foto_atividade"]!)
                                
                                
                                aux.tipo_atividade = "minicurso"
                                let imageUrl = NSURL(string: aux.foto_atividade)
                                let data = NSData(contentsOfURL: imageUrl!)
                                aux.imagem_atividade = UIImage(data: data!)
                                
                                self.atividades.append(aux)
                                
                            }
                            
                            if let workshops = json["workshops"] as? [[String: String]] {
                                for minicurso in workshops {
                                    
                                    let aux = AtividadeAux(nome_atividade: minicurso["nome_atividade"]!, descricao_atividade: minicurso["descricao_atividade"]!, data_inicio_atividade: minicurso["data_inicio_atividade"]!, hora_inicio_atividade: minicurso["hora_inicio_atividade"]!, hora_fim_atividade: minicurso["hora_fim_atividade"]!, hora_retorno_atividade: nil, hora_fim_retorno_atividade: nil, local_atividade: minicurso["local_atividade"]!, ministrante_atividade: minicurso["ministrante_atividade"]!, foto_atividade: minicurso["foto_atividade"]!)
                                    
                                    
                                    aux.tipo_atividade = "workshop"
                                    let imageUrl = NSURL(string: aux.foto_atividade)
                                    let data = NSData(contentsOfURL: imageUrl!)
                                    aux.imagem_atividade = UIImage(data: data!)
                                    
                                    self.atividades.append(aux)
                                    
                                }
                            }
                        }
                        
                        AtividadeDAO.atualizarBanco(self.atividades)
                        AtividadeDAO.atualizarDados()
                        
                    } else {
                        print("Não consegui fazer o parsing :(")
                    }
                } catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        
        task.resume()
        
        return true
    }
    
}