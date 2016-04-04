//
//  ReceitasViewController.swift
//  Budget
//
//  Created by Yuri Pereira on 3/23/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import CoreData

class ReceitasViewController: UITableViewController, ContasViewControllerDelegate, CategoriaViewControllerDelegate, LocalViewControllerDelegate  {

    var erros: String = ""
    var conta: Conta? = nil
    var categoria: Categoria? = nil
    var receita: Receita?
    var local: Local? = nil
    let receitaDAO:ReceitaDAO = ReceitaDAO()
    var pickerView: UIDatePicker!
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var navegacao: UINavigationItem!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var txtEndereco: UITextField!
    @IBOutlet weak var txtConta: UITextField!
    @IBOutlet weak var txtCategoria: UITextField!
    @IBOutlet weak var txtData: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIDatePicker()
        pickerView.datePickerMode = UIDatePickerMode.Date
        pickerView.addTarget(self, action: "updateTextField:", forControlEvents: .ValueChanged)
        
        if let receita = receita {
            txtNome.text = receita.nome!
            txtValor.text = String(receita.valor!)
            txtDescricao.text = receita.descricao!
            txtData.text = Data.formatDateToString(receita.data!)
            conta = receita.conta //as? Conta
            categoria = receita.categoria //as? Categoria
            local = receita.local
            
            navegacao.title = "Alterar"
            txtValor.enabled = false
            txtData.enabled = false
            txtConta.enabled = false
            
        } else {
            txtData.text = Data.formatDateToString(pickerView.date)
        }
        
        txtConta.text = self.conta?.nome!
        txtCategoria.text = self.categoria?.nome!
        txtEndereco.text = self.local?.nome! // Local
        
        txtData.inputView = pickerView
        
        // Alinhar as labels
        FormCustomization.updateWidthsForLabels(labels)
        


    }
    
    func updateTextField(sender:UIDatePicker){
        txtData.text = Data.formatDateToString(sender.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dissmissViewController(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        dissmissViewController()
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        if receita != nil {
            updateConta()
        }else{
            addConta()
            
        }
    }
    
    @IBAction func maskTextField(sender: UITextField) {
        FormCustomization.aplicarMascara(&sender.text!)
    }
    
    func validarCampos(){
        if Validador.vazio(txtNome.text!){
            erros.appendContentsOf("Preencha o campo nome!\n")
        }
        
        if Validador.vazio(txtValor.text!){
            erros.appendContentsOf("Preencha o campo Valor!\n")
        }
        
        if Validador.vazio(txtEndereco.text!){
            erros.appendContentsOf("Selecione o Local!\n")
        }
        
        if Validador.vazio(txtConta.text!){
            erros.appendContentsOf("Selecione a Conta!\n")
        }
        
        if Validador.vazio(txtCategoria.text!){
            erros.appendContentsOf("Selecione a Categoria!")
        }
    }
    
    func addConta(){
        
        validarCampos()
        
        if(erros.isEmpty){
            receita = Receita.getReceita()
            receita?.nome = txtNome.text
            receita?.descricao = txtDescricao.text
            receita?.valor = txtValor.text!.floatConverterMoeda()
            receita?.conta = conta
            receita?.categoria = categoria
            receita?.local = local
            receita?.data = Data.removerTime(txtData.text!)
            
            // Atualizar o saldo da conta referente
            conta?.saldo = Float((receita?.valor)!) + Float((conta?.saldo)!)
            
            do{
                try receitaDAO.salvar(receita!)
                navigationController?.popViewControllerAnimated(true)
            }catch{
                let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível registrar")
                presentViewController(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            erros.removeAll()
        }

    }
    
    func updateConta(){
        
        validarCampos()
        
        if(erros.isEmpty){
            receita?.nome = txtNome.text
            receita?.descricao = txtDescricao.text
            
            if let categoria = categoria{
                receita?.categoria = categoria
            }
            
            if let local = local{
                receita?.local = local
            }
            
            do{
                try receitaDAO.salvar(receita!)
                navigationController?.popViewControllerAnimated(true)
            }catch{
                let alert = Notification.mostrarErro("Desculpe", mensagem: "Não foi possível atualizar")
                presentViewController(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = Notification.mostrarErro("Campos vazio", mensagem: "\(erros)")
            presentViewController(alert, animated: true, completion: nil)
            erros.removeAll()
        }
        
        
//        receita?.valor = Float(txtValor.text!)

//        receita?.data = Data.removerTime(txtData.text!)
        
//        if let conta = conta {
//            receita?.conta? = conta
//        }
        

    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if receita == nil{
            return true
        }
        
        if identifier == "alterarCategoriaReceita"{
            return true
        }
        
        if identifier == "alterarLocalReceita"{
            return true
        }
        
        return false
    }
    
    // Define Delegate Method
    func contasViewControllerResponse(conta: Conta) {
        self.conta = conta
        txtConta.text = conta.nome
    }
    
    func categoriaViewControllerResponse(categoria:Categoria){
        self.categoria = categoria
        txtCategoria.text = categoria.nome
    }
    
    func localViewControllerResponse(local:Local){
        self.local = local
        txtEndereco.text = local.nome
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section) {
        case 0: return 5    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        case 2: return 1    // section 2 has 1 row
        default: fatalError("Unknown number of sections")
        }
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        FormCustomization.dismissInputView([txtNome, txtDescricao, txtValor, txtData])
        
        if segue.identifier == "alterarConta"{
            let contasController : ContasTableViewController = segue.destinationViewController as! ContasTableViewController
            contasController.delegate = self
            contasController.telaReceita = true
        }else if segue.identifier == "alterarCategoriaReceita"{
            let categoriasController : CategoriaTableViewController = segue.destinationViewController as! CategoriaTableViewController
            categoriasController.delegate = self
            
        }else if segue.identifier == "alterarLocalReceita"{
            let locaisController : LocalTableViewController = segue.destinationViewController as! LocalTableViewController
            locaisController.delegate = self
            locaisController.tela = true
            
        }
        
    }

}
